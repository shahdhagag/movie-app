import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String photoUrl;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber, photoUrl];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class ClearAuthStateEvent extends AuthEvent {
  const ClearAuthStateEvent();
}

class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();
}
