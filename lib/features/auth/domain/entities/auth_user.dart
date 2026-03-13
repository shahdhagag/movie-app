import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNumber;
  final bool isEmailVerified;
  final String? photoUrl;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    phoneNumber,
    isEmailVerified,
    photoUrl,
  ];
}

