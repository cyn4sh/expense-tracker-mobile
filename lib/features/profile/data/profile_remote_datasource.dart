import 'package:dio/dio.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_error_handler.dart';
import '../../auth/data/models/user_model.dart';

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('me/');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ParseException();
    }
  }

  Future<UserModel> updateNotifications(bool enabled) async {
    try {
      final response = await _dio.patch(
        'me/',
        data: {'notifications_enabled': enabled},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}