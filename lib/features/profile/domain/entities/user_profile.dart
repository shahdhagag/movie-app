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

