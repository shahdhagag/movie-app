import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Data Loading Events
class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile();
}

class FetchWatchList extends ProfileEvent {
  const FetchWatchList();
}

class FetchHistory extends ProfileEvent {
  const FetchHistory();
}

// Stream Listening Events (Real-time Updates)
class StartWatchingWatchList extends ProfileEvent {
  const StartWatchingWatchList();
}

class StartWatchingHistory extends ProfileEvent {
  const StartWatchingHistory();
}

class StartWatchingProfile extends ProfileEvent {
  const StartWatchingProfile();
}

// Watchlist Operations
class AddToWatchList extends ProfileEvent {
  final int movieId;
  final String title;
  final String posterPath;

  const AddToWatchList({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath];
}

class RemoveFromWatchList extends ProfileEvent {
  final int movieId;

  const RemoveFromWatchList({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}

class CheckMovieInWatchList extends ProfileEvent {
  final int movieId;

  const CheckMovieInWatchList({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}

// History Operations
class AddToHistory extends ProfileEvent {
  final int movieId;
  final String title;
  final String posterPath;

  const AddToHistory({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath];
}

class RemoveFromHistory extends ProfileEvent {
  final int movieId;

  const RemoveFromHistory({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}

class CheckMovieInHistory extends ProfileEvent {
  final int movieId;

  const CheckMovieInHistory({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}

// Profile Management Events
class UpdateProfile extends ProfileEvent {
  final String displayName;
  final String phoneNumber;
  final String? bio;
  final String? photoUrl;

  const UpdateProfile({
    required this.displayName,
    required this.phoneNumber,
    this.bio,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, bio, photoUrl];
}

class SwitchTabEvent extends ProfileEvent {
  final int tabIndex;

  const SwitchTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

// Auth Events
class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}

class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}

// Stream Update Events
class WatchListUpdated extends ProfileEvent {
  final List<dynamic> watchList;

  const WatchListUpdated({required this.watchList});

  @override
  List<Object?> get props => [watchList];
}

class HistoryUpdated extends ProfileEvent {
  final List<dynamic> history;

  const HistoryUpdated({required this.history});

  @override
  List<Object?> get props => [history];
}

class ProfileUpdated extends ProfileEvent {
  final dynamic profile;

  const ProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}


