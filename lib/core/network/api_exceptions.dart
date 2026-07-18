class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No internet connection. Please try again.']);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Session expired. Please log in again.']);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Something went wrong on our end. Please try again later.']);
}

class ParseException extends ApiException {
  ParseException([super.message = 'Unexpected response format.']);
}