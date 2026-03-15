import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthUser user;
  final String message;

  const AuthSuccess({
    required this.user,
    this.message = 'Operation successful',
  });

  @override
  List<Object?> get props => [user, message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class EmailVerificationSent extends AuthState {
  final String message;

  const EmailVerificationSent(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetEmailSent extends AuthState {
  final String message;

  const PasswordResetEmailSent(this.message);

  @override
  List<Object?> get props => [message];
}
class LoginLoading extends AuthState {}
class GoogleLoading extends AuthState {}

