import '../../auth/data/models/user_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepository(this._remoteDatasource);

  Future<UserModel> getMe() => _remoteDatasource.getMe();

  Future<UserModel> updateNotifications(bool enabled) =>
      _remoteDatasource.updateNotifications(enabled);
}