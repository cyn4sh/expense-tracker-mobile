import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/auth_repository.dart';
import '../data/auth_remote_datasource.dart';
import '../data/login_dto.dart';
import '../data/signup_dto.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../profile/data/profile_provider.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(
    AuthRemoteDatasource(apiClient.dio),
    SecureStorageService(),
  );
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {
    // No initial async work needed yet — state starts idle.
  }

  Future<void> login(LoginDto dto) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repository.login(dto));
  }

  Future<void> signup(SignupDto dto) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repository.signup(dto);
      await repository.login(LoginDto(username: dto.username, password: dto.password));
    });
  }

  Future<void> loginWithGoogle() async {
    debugPrint('>>> loginWithGoogle() called');
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      debugPrint('>>> calling GoogleSignIn.instance.authenticate()');
      final account = await GoogleSignIn.instance.authenticate().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Google authenticate() timed out after 15s'),
      );
      debugPrint('>>> authenticate() returned: ${account.email}');
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw Exception('Google sign-in did not return an ID token');
      }
      await repository.loginWithGoogle(idToken);
    });
    debugPrint('>>> loginWithGoogle() finished, state: $state');
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
  }
}

@riverpod
Future<bool> isLoggedIn(Ref ref) async {
  final secureStorage = SecureStorageService();
  final token = await secureStorage.getAccessToken();
  if (token == null || token.isEmpty) {
    return false;
  }
  try {
    final profileRepository = ref.read(profileRepositoryProvider);
    await profileRepository.getMe();
    return true;
  } catch (_) {
    return false;
  }
}