import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/profile_provider.dart';

part 'email_verified_provider.g.dart';

@riverpod
Future<bool> emailVerified(Ref ref) async {
  final profileRepository = ref.read(profileRepositoryProvider);
  final user = await profileRepository.getMe();
  return user.emailVerified ?? true;
}