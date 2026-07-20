import 'package:dio/dio.dart';
import '../../../core/network/api_error_handler.dart';
import 'login_dto.dart';
import 'signup_dto.dart';
import 'models/user_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> login(LoginDto dto) async {
    try {
      final response = await _dio.post('token/', data: dto.toJson());
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<UserModel> signup(SignupDto dto) async {
    try {
      final response = await _dio.post('register/', data: dto.toJson());
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post('auth/google/', data: {'id_token': idToken});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}