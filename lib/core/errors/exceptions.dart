/// Custom Exceptions

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed']);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = 'Validation failed']);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized access']);

  @override
  String toString() => message;
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Request timeout']);

  @override
  String toString() => message;
}

