import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../data/auth_remote_datasource.dart';
import '../data/login_dto.dart';
import '../data/signup_dto.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/secure_storage_service.dart';

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

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
  }
}

@riverpod
Future<bool> isLoggedIn(Ref ref) async {
  final secureStorage = SecureStorageService();
  final token = await secureStorage.getAccessToken();
  return token != null && token.isNotEmpty;
}