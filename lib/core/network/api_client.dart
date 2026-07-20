import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import '../config/app_config.dart';

class ApiClient {
  late final Dio dio;
  final SecureStorageService _secureStorage = SecureStorageService();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.getRefreshToken();

            if (refreshToken != null) {
              try {
                final response = await Dio().post(
                  '${AppConfig.apiBaseUrl}token/refresh/',
                  data: {'refresh': refreshToken},
                );

                final newAccessToken = response.data['access'];
                await _secureStorage.saveAccessToken(newAccessToken);

                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final retryResponse = await dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              } catch (e) {
                await _secureStorage.clearTokens();
                return handler.next(error);
              }
            } else {
              await _secureStorage.clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}