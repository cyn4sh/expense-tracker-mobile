import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'profile_repository.dart';
import 'profile_remote_datasource.dart';
import '../../../core/network/api_client_provider.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepository(ProfileRemoteDatasource(apiClient.dio));
}

@riverpod
class NotificationPrefsNotifier extends _$NotificationPrefsNotifier {
  @override
  Future<bool> build() async {
    final repository = ref.read(profileRepositoryProvider);
    final user = await repository.getMe();
    return user.notificationsEnabled;
  }

  Future<void> toggle() async {
    final current = state.value ?? true;
    final repository = ref.read(profileRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final updated = await repository.updateNotifications(!current);
      return updated.notificationsEnabled;
    });
  }
}