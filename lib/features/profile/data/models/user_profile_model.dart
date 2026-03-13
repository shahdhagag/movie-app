import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String? photoUrl;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int watchListCount;
  final int historyCount;

  const UserProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    this.photoUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.watchListCount = 0,
    this.historyCount = 0,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      watchListCount: json['watchListCount'] as int? ?? 0,
      historyCount: json['historyCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'phoneNumber': phoneNumber,
    'photoUrl': photoUrl,
    'bio': bio,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'watchListCount': watchListCount,
    'historyCount': historyCount,
  };

  UserProfile toEntity() {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
      watchListCount: watchListCount,
      historyCount: historyCount,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    phoneNumber,
    photoUrl,
    bio,
    createdAt,
    updatedAt,
    watchListCount,
    historyCount,
  ];
}

