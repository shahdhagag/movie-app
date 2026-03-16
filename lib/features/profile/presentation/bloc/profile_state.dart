import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_item.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ProfileInitial extends ProfileState {}

// Loading States
class ProfileLoading extends ProfileState {}

class ActionLoading extends ProfileState {
  final String action;

  const ActionLoading({required this.action});

  @override
  List<Object> get props => [action];
}

// Success States
class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  final List<MovieItem> watchList;
  final List<MovieItem> history;
  final int selectedTabIndex;

  const ProfileLoaded({
    required this.userProfile,
    required this.watchList,
    required this.history,
    this.selectedTabIndex = 0,
  });

  ProfileLoaded copyWith({
    UserProfile? userProfile,
    List<MovieItem>? watchList,
    List<MovieItem>? history,
    int? selectedTabIndex,
  }) {
    return ProfileLoaded(
      userProfile: userProfile ?? this.userProfile,
      watchList: watchList ?? this.watchList,
      history: history ?? this.history,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [userProfile, watchList, history, selectedTabIndex];
}

class WatchListLoading extends ProfileState {}

class WatchListLoaded extends ProfileState {
  final List<MovieItem> watchList;

  const WatchListLoaded({required this.watchList});

  @override
  List<Object> get props => [watchList];
}

class HistoryLoading extends ProfileState {}

class HistoryLoaded extends ProfileState {
  final List<MovieItem> history;

  const HistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

// CRUD Operation States
class MovieAddedToWatchList extends ProfileState {
  final int movieId;

  const MovieAddedToWatchList({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieRemovedFromWatchList extends ProfileState {
  final int movieId;

  const MovieRemovedFromWatchList({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieAddedToHistory extends ProfileState {
  final int movieId;

  const MovieAddedToHistory({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieRemovedFromHistory extends ProfileState {
  final int movieId;

  const MovieRemovedFromHistory({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieInWatchListStatus extends ProfileState {
  final int movieId;
  final bool isInWatchList;

  const MovieInWatchListStatus({
    required this.movieId,
    required this.isInWatchList,
  });

  @override
  List<Object> get props => [movieId, isInWatchList];
}

class MovieInHistoryStatus extends ProfileState {
  final int movieId;
  final bool isInHistory;

  const MovieInHistoryStatus({
    required this.movieId,
    required this.isInHistory,
  });

  @override
  List<Object> get props => [movieId, isInHistory];
}

class ProfileUpdatedSuccess extends ProfileState {
  final UserProfile? updatedProfile;

  const ProfileUpdatedSuccess({this.updatedProfile});

  @override
  List<Object?> get props => [updatedProfile];
}
class WatchListStreaming extends ProfileState {
  final List<MovieItem> watchList;

  const WatchListStreaming({required this.watchList});

  @override
  List<Object> get props => [watchList];
}

class HistoryStreaming extends ProfileState {
  final List<MovieItem> history;

  const HistoryStreaming({required this.history});

  @override
  List<Object> get props => [history];
}

class ProfileStreaming extends ProfileState {
  final UserProfile userProfile;

  const ProfileStreaming({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

// Error States
class ProfileError extends ProfileState {
  final String message;
  final String? actionType;

  const ProfileError({
    required this.message,
    this.actionType,
  });

  @override
  List<Object?> get props => [message, actionType];
}

class ActionError extends ProfileState {
  final String message;
  final String action;

  const ActionError({
    required this.message,
    required this.action,
  });

  @override
  List<Object> get props => [message, action];
}

// Auth Success States
class LogoutSuccess extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}


