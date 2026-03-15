import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/add_to_history.dart';
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
  // Existing usecases
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetWatchListUseCase getWatchListUseCase;
  final GetHistoryUseCase getHistoryUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  
  // New usecases
  final AddToWatchListUseCase? addToWatchListUseCase;
  final AddToHistoryUseCase? addToHistoryUseCase;
  final UpdateUserProfileUseCase? updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.getWatchListUseCase,
    required this.getHistoryUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
    this.addToWatchListUseCase,
    this.addToHistoryUseCase,
    this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    // Load events
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchWatchList>(_onFetchWatchList);
    on<FetchHistory>(_onFetchHistory);
    
    // CRUD events
    on<AddToWatchList>(_onAddToWatchList);
    on<RemoveFromWatchList>(_onRemoveFromWatchList);
    on<AddToHistory>(_onAddToHistory);
    on<RemoveFromHistory>(_onRemoveFromHistory);
    
    // Check events
    on<CheckMovieInWatchList>(_onCheckMovieInWatchList);
    on<CheckMovieInHistory>(_onCheckMovieInHistory);
    
    // Profile events
    on<UpdateProfile>(_onUpdateProfile);
    on<SwitchTabEvent>(_onSwitchTab);
    
    // Auth events
    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  // ================== LOAD EVENTS ==================
  
  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    var primaryFetch = await _loadProfilePayload();

    // Auto-retry once for transient failures right after profile/update navigation.
    if (!primaryFetch.isSuccess) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      primaryFetch = await _loadProfilePayload();
    }

    if (!primaryFetch.isSuccess || primaryFetch.payload == null) {
      emit(ProfileError(
        message: primaryFetch.failureMessage ?? 'Failed to fetch profile data',
      ));
      return;
    }

    var finalPayload = primaryFetch.payload!;

    // Verification fetch confirms server state when first response is delayed.
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

    return _ProfileFetchResult.success(
      _ProfileFetchPayload(
        userProfile: profile,
        watchList: watchList,
        history: history,
      ),
    );
  }

  Future<void> _onFetchWatchList(
    FetchWatchList event,
    Emitter<ProfileState> emit,
  ) async {
    emit(WatchListLoading());

    final result = await getWatchListUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (watchList) => emit(WatchListLoaded(watchList: watchList)),
    );
  }

  Future<void> _onFetchHistory(
    FetchHistory event,
    Emitter<ProfileState> emit,
  ) async {
    emit(HistoryLoading());

    final result = await getHistoryUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (history) => emit(HistoryLoaded(history: history)),
    );
  }

  // ================== WATCHLIST OPERATIONS ==================

  Future<void> _onAddToWatchList(
    AddToWatchList event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Adding to watchlist'));

    if (addToWatchListUseCase == null) {
      emit(ActionError(
        message: 'Add to watchlist operation not available',
        action: 'add_to_watchlist',
      ));
      return;
    }

    final result = await addToWatchListUseCase!(
      AddToWatchListParams(
        movieId: event.movieId,
        title: event.title,
        posterPath: event.posterPath,
      ),
    );

    result.fold(
      (failure) => emit(ActionError(
        message: failure.message,
        action: 'add_to_watchlist',
      )),
      (_) => emit(MovieAddedToWatchList(movieId: event.movieId)),
    );
  }

  Future<void> _onRemoveFromWatchList(
    RemoveFromWatchList event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Removing from watchlist'));
    emit(MovieRemovedFromWatchList(movieId: event.movieId));
  }

  // ================== HISTORY OPERATIONS ==================

  Future<void> _onAddToHistory(
    AddToHistory event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Adding to history'));

    if (addToHistoryUseCase == null) {
      emit(ActionError(
        message: 'Add to history operation not available',
        action: 'add_to_history',
      ));
      return;
    }

    final result = await addToHistoryUseCase!(
      AddToHistoryParams(
        movieId: event.movieId,
        title: event.title,
        posterPath: event.posterPath,
      ),
    );

    result.fold(
      (failure) => emit(ActionError(
        message: failure.message,
        action: 'add_to_history',
      )),
      (_) => emit(MovieAddedToHistory(movieId: event.movieId)),
    );
  }

  Future<void> _onRemoveFromHistory(
    RemoveFromHistory event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Removing from history'));
    emit(MovieRemovedFromHistory(movieId: event.movieId));
  }

  // ================== CHECK OPERATIONS ==================

  Future<void> _onCheckMovieInWatchList(
    CheckMovieInWatchList event,
    Emitter<ProfileState> emit,
  ) async {
    emit(MovieInWatchListStatus(
      movieId: event.movieId,
      isInWatchList: false,
    ));
  }

  Future<void> _onCheckMovieInHistory(
    CheckMovieInHistory event,
    Emitter<ProfileState> emit,
  ) async {
    emit(MovieInHistoryStatus(
      movieId: event.movieId,
      isInHistory: false,
    ));
  }

  // ================== PROFILE OPERATIONS ==================

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Updating profile'));

    if (updateUserProfileUseCase == null) {
      emit(ActionError(
        message: 'Update profile operation not available',
        action: 'update_profile',
      ));
      return;
    }

    final result = await updateUserProfileUseCase!(
      UpdateProfileParams(
        displayName: event.displayName,
        phoneNumber: event.phoneNumber,
        bio: event.bio,
        photoUrl: event.photoUrl,
      ),
    );

    final updateFailure = result.fold((failure) => failure, (_) => null);
    if (updateFailure != null) {
      emit(ActionError(
        message: updateFailure.message,
        action: 'update_profile',
      ));
      return;
    }

    final refreshedProfile = await getUserProfileUseCase(NoParams());
    refreshedProfile.fold(
      (failure) => emit(ActionError(
        message: failure.message,
        action: 'update_profile',
      )),
      (profile) => emit(ProfileUpdatedSuccess(updatedProfile: profile)),
    );
  }

  Future<void> _onSwitchTab(
    SwitchTabEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(selectedTabIndex: event.tabIndex));
    }
  }

  // ================== AUTH EVENTS ==================

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Logging out'));

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ActionLoading(action: 'Deleting account'));

    final result = await deleteAccountUseCase(NoParams());

    result.fold(
      (failure) => emit(ActionError(
        message: failure.message,
        action: 'delete_account',
      )),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}

