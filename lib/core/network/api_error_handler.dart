import 'package:dio/dio.dart';
import 'api_exceptions.dart';

String _extractValidationMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final nonFieldErrors = data['non_field_errors'];
    if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
      return nonFieldErrors.first.toString();
    }

    for (final value in data.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
  } else if (data is String && data.isNotEmpty) {
    return data;
  }

  return 'Invalid input.';
}

ApiException handleDioError(DioException e) {
  if (e.response?.statusCode == 401) {
    return UnauthorizedException();
  } else if (e.response?.statusCode == 400) {
    return ApiException(_extractValidationMessage(e.response?.data));
  } else if (e.response != null && e.response!.statusCode! >= 500) {
    return ServerException();
  } else if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.connectionError) {
    return NetworkException();
  }
  return ApiException(e.message ?? 'An unexpected error occurred.');
}
