import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/services/auth_service.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/add_to_history.dart';
import '../../domain/usecases/remove_from_watchlist.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/entities/movie_item.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/usecases/usecase.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class _ProfileFetchPayload {
  final UserProfile userProfile;
  final List<MovieItem> watchList;
  final List<MovieItem> history;

  _ProfileFetchPayload({
    required this.userProfile,
    required this.watchList,
    required this.history,
  });
}

class _ProfileFetchResult {
  final _ProfileFetchPayload? payload;
  final String? failureMessage;

  const _ProfileFetchResult._({this.payload, this.failureMessage});

  bool get isSuccess => payload != null;

  factory _ProfileFetchResult.success(_ProfileFetchPayload payload) {
    return _ProfileFetchResult._(payload: payload);
  }

  factory _ProfileFetchResult.failure(String message) {
    return _ProfileFetchResult._(failureMessage: message);
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetWatchListUseCase getWatchListUseCase;
  final GetHistoryUseCase getHistoryUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  final AddToWatchListUseCase? addToWatchListUseCase;
  final RemoveFromWatchListUseCase? removeFromWatchListUseCase;
  final AddToHistoryUseCase? addToHistoryUseCase;
  final UpdateUserProfileUseCase? updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.getWatchListUseCase,
    required this.getHistoryUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
    this.addToWatchListUseCase,
    this.removeFromWatchListUseCase,
    this.addToHistoryUseCase,
    this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchWatchList>(_onFetchWatchList);
    on<FetchHistory>(_onFetchHistory);

    on<AddToWatchList>(_onAddToWatchList);
    on<RemoveFromWatchList>(_onRemoveFromWatchList);
    on<AddToHistory>(_onAddToHistory);
    on<RemoveFromHistory>(_onRemoveFromHistory);

    on<CheckMovieInWatchList>(_onCheckMovieInWatchList);
    on<CheckMovieInHistory>(_onCheckMovieInHistory);

    on<UpdateProfile>(_onUpdateProfile);
    on<SwitchTabEvent>(_onSwitchTab);

    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onFetchUserProfile(FetchUserProfile event, Emitter<ProfileState> emit) async {
    final auth = getIt<AuthService>();
    if (!auth.isLoggedIn) {
      // Avoid calling backend if user is not authenticated
      emit(ProfileError(message: 'Not authenticated'));
      return;
    }

    emit(ProfileLoading());

    var primaryFetch = await _loadProfilePayload();

    if (!primaryFetch.isSuccess) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      primaryFetch = await _loadProfilePayload();
    }

    if (!primaryFetch.isSuccess || primaryFetch.payload == null) {

      print('[ProfileBloc] _onFetchUserProfile failed: ${primaryFetch.failureMessage}');
      emit(ProfileError(message: primaryFetch.failureMessage ?? 'Failed to fetch profile data'));
      return;
    }

    var finalPayload = primaryFetch.payload!;

    if (event.verifyFreshness) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final verificationFetch = await _loadProfilePayload();
      if (verificationFetch.isSuccess && verificationFetch.payload != null) {
        finalPayload = verificationFetch.payload!;
      }
    }

    emit(ProfileLoaded(
      userProfile: finalPayload.userProfile,
      watchList: finalPayload.watchList,
      history: finalPayload.history,
      selectedTabIndex: event.selectedTabIndex,
    ));
  }

  Future<_ProfileFetchResult> _loadProfilePayload() async {
    final profileResult = await getUserProfileUseCase(NoParams());
    final profileFailure = profileResult.fold((failure) => failure, (_) => null);
    if (profileFailure != null) {
      return _ProfileFetchResult.failure(profileFailure.message);
    }
    final profile = profileResult.fold((_) => null, (value) => value)!;

    final watchListResult = await getWatchListUseCase(NoParams());
    final watchListFailure = watchListResult.fold((failure) => failure, (_) => null);
    if (watchListFailure != null) {
      return _ProfileFetchResult.failure(watchListFailure.message);
    }
    final watchList = watchListResult.fold((_) => null, (value) => value)!;

    final historyResult = await getHistoryUseCase(NoParams());
    final historyFailure = historyResult.fold((failure) => failure, (_) => null);
    if (historyFailure != null) {
      return _ProfileFetchResult.failure(historyFailure.message);
    }
    final history = historyResult.fold((_) => null, (value) => value)!;

    return _ProfileFetchResult.success(_ProfileFetchPayload(userProfile: profile, watchList: watchList, history: history));
  }

  Future<void> _onFetchWatchList(FetchWatchList event, Emitter<ProfileState> emit) async {
    emit(WatchListLoading());
    final result = await getWatchListUseCase(NoParams());
    result.fold((failure) => emit(ProfileError(message: failure.message)), (watchList) => emit(WatchListLoaded(watchList: watchList)));
  }

  Future<void> _onFetchHistory(FetchHistory event, Emitter<ProfileState> emit) async {
    emit(HistoryLoading());
    final result = await getHistoryUseCase(NoParams());
    result.fold((failure) => emit(ProfileError(message: failure.message)), (history) => emit(HistoryLoaded(history: history)));
  }

  Future<void> _onSwitchTab(SwitchTabEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(selectedTabIndex: event.tabIndex));
    }
  }

  Future<void> _onAddToWatchList(AddToWatchList event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Adding to watchlist'));

    if (addToWatchListUseCase == null) {
      emit(ActionError(message: 'Add to watchlist operation not available', action: 'add_to_watchlist'));
      return;
    }

    final result = await addToWatchListUseCase!(AddToWatchListParams(movieId: event.movieId, title: event.title, posterPath: event.posterPath));

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(ActionError(message: failure.message, action: 'add_to_watchlist'));
      return;
    }

    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final exists = current.watchList.any((m) => m.movieId == event.movieId);
      if (!exists) {
        final newItem = MovieItem(movieId: event.movieId, title: event.title, posterPath: event.posterPath, addedAt: DateTime.now());
        final updatedWatchList = List<MovieItem>.from(current.watchList);
        updatedWatchList.insert(0, newItem);
        emit(current.copyWith(watchList: updatedWatchList));
      } else {
        emit(current);
      }
    } else {
      add(const FetchUserProfile());
    }
  }

  Future<void> _onRemoveFromWatchList(RemoveFromWatchList event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Removing from watchlist'));

    if (removeFromWatchListUseCase == null) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        final updated = current.watchList.where((m) => m.movieId != event.movieId).toList();
        emit(current.copyWith(watchList: updated));
      }
      emit(ActionError(message: 'Remove from watchlist operation not available', action: 'remove_from_watchlist'));
      return;
    }

    List<MovieItem>? previousWatchList;
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      previousWatchList = List<MovieItem>.from(current.watchList);
      final updated = current.watchList.where((m) => m.movieId != event.movieId).toList();
      emit(current.copyWith(watchList: updated));
    }

    final result = await removeFromWatchListUseCase!(RemoveFromWatchListParams(movieId: event.movieId));
    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      if (state is ProfileLoaded && previousWatchList != null) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(watchList: previousWatchList));
      }
      emit(ActionError(message: failure.message, action: 'remove_from_watchlist'));
      return;
    }
  }

  Future<void> _onAddToHistory(AddToHistory event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Adding to history'));

    if (addToHistoryUseCase == null) {
      emit(ActionError(message: 'Add to history operation not available', action: 'add_to_history'));
      return;
    }

    final result = await addToHistoryUseCase!(AddToHistoryParams(movieId: event.movieId, title: event.title, posterPath: event.posterPath));

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(ActionError(message: failure.message, action: 'add_to_history'));
      return;
    }

    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final exists = current.history.any((m) => m.movieId == event.movieId);
      if (!exists) {
        final newItem = MovieItem(movieId: event.movieId, title: event.title, posterPath: event.posterPath, addedAt: DateTime.now());
        final updatedHistory = List<MovieItem>.from(current.history);
        updatedHistory.insert(0, newItem);
        emit(current.copyWith(history: updatedHistory));
      } else {
        emit(current);
      }
    } else {
      add(const FetchUserProfile());
    }
  }

  Future<void> _onRemoveFromHistory(RemoveFromHistory event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Removing from history'));

    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.history.where((m) => m.movieId != event.movieId).toList();
      emit(current.copyWith(history: updated));
    } else {
      add(const FetchUserProfile());
    }
  }

  Future<void> _onCheckMovieInWatchList(CheckMovieInWatchList event, Emitter<ProfileState> emit) async {
    final inList = (state is ProfileLoaded) && (state as ProfileLoaded).watchList.any((m) => m.movieId == event.movieId);
    emit(MovieInWatchListStatus(movieId: event.movieId, isInWatchList: inList));
  }

  Future<void> _onCheckMovieInHistory(CheckMovieInHistory event, Emitter<ProfileState> emit) async {
    final inHistory = (state is ProfileLoaded) && (state as ProfileLoaded).history.any((m) => m.movieId == event.movieId);
    emit(MovieInHistoryStatus(movieId: event.movieId, isInHistory: inHistory));
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (updateUserProfileUseCase == null) {
      emit(ActionError(message: 'Update profile operation not available', action: 'update_profile'));
      return;
    }

    UserProfile? previousProfile;
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      previousProfile = current.userProfile;

      final optimisticProfile = current.userProfile.copyWith(
        displayName: event.displayName,
        phoneNumber: event.phoneNumber,
        photoUrl: event.photoUrl,
        bio: event.bio ?? current.userProfile.bio,
      );

      emit(current.copyWith(userProfile: optimisticProfile));
      emit(ProfileUpdatedSuccess(updatedProfile: optimisticProfile));
      emit(current.copyWith(userProfile: optimisticProfile));
    } else {
      emit(ProfileUpdatedSuccess(updatedProfile: null));
    }

    final result = await updateUserProfileUseCase!(UpdateProfileParams(displayName: event.displayName, phoneNumber: event.phoneNumber, bio: event.bio, photoUrl: event.photoUrl));

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      if (previousProfile != null && state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(userProfile: previousProfile));
      }
      emit(ActionError(message: failure.message, action: 'update_profile'));
      return;
    }

    final serverProfileResult = await getUserProfileUseCase(NoParams());
    serverProfileResult.fold((_) => null, (serverProfile) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        if (serverProfile != current.userProfile) {
          emit(current.copyWith(userProfile: serverProfile));
        }
      }
    });
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Logging out'));

    final result = await logoutUseCase(NoParams());

    result.fold((failure) => emit(ProfileError(message: failure.message)), (_) => emit(LogoutSuccess()));
  }

  Future<void> _onDeleteAccount(DeleteAccountEvent event, Emitter<ProfileState> emit) async {
    emit(ActionLoading(action: 'Deleting account'));

    final result = await deleteAccountUseCase(NoParams());

    result.fold((failure) => emit(ActionError(message: failure.message, action: 'delete_account')), (_) => emit(DeleteAccountSuccess()));
  }
}