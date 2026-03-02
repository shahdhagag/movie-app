import 'package:equatable/equatable.dart';

/// Base Failure class
abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = '']);

  @override
  List<Object?> get props => [message];
}

/// Server Failure
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Authentication Failure
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Validation Failure
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Not Found Failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Unauthorized Failure
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Timeout Failure
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
}