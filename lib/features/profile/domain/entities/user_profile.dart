import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
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

  const UserProfile({
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

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? watchListCount,
    int? historyCount,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      watchListCount: watchListCount ?? this.watchListCount,
      historyCount: historyCount ?? this.historyCount,
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