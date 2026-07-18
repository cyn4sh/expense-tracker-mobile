import '../../../core/storage/secure_storage_service.dart';
import 'auth_remote_datasource.dart';
import 'login_dto.dart';
import 'signup_dto.dart';
import 'models/user_model.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SecureStorageService _secureStorageService;

  AuthRepository(this._remoteDatasource, this._secureStorageService);

  Future<void> login(LoginDto dto) async {
    final tokens = await _remoteDatasource.login(dto);
    await _secureStorageService.saveAccessToken(tokens['access'] as String);
    await _secureStorageService.saveRefreshToken(tokens['refresh'] as String);
  }

  Future<UserModel> signup(SignupDto dto) async {
    return _remoteDatasource.signup(dto);
  }

  Future<void> logout() async {
    await _secureStorageService.clearTokens();
  }
}