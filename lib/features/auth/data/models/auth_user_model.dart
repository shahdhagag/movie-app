import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required String uid,
    required String email,
    required String displayName,
    required String phoneNumber,
    required bool isEmailVerified,
    required String? photoUrl,
  }) : super(
    uid: uid,
    email: email,
    displayName: displayName,
    phoneNumber: phoneNumber,
    isEmailVerified: isEmailVerified,
    photoUrl: photoUrl,
  );

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'photoUrl': photoUrl,
    };
  }

  AuthUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    bool? isEmailVerified,
    String? photoUrl,
  }) {
    return AuthUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

