import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_item.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

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
  List<Object> get props => [userProfile, watchList, history, selectedTabIndex];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
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

class LogoutSuccess extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}

