import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/add_to_history.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../../../core/usecases/usecase.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

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

    final profileResult = await getUserProfileUseCase(NoParams());
    final watchListResult = await getWatchListUseCase(NoParams());
    final historyResult = await getHistoryUseCase(NoParams());

    profileResult.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) {
        watchListResult.fold(
          (failure) => emit(ProfileError(message: failure.message)),
          (watchList) {
            historyResult.fold(
              (failure) => emit(ProfileError(message: failure.message)),
              (history) {
                emit(ProfileLoaded(
                  userProfile: profile,
                  watchList: watchList,
                  history: history,
                ));
              },
            );
          },
        );
      },
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

    result.fold(
      (failure) => emit(ActionError(
        message: failure.message,
        action: 'update_profile',
      )),
      (_) {
        if (state is ProfileLoaded) {
          emit(ProfileUpdatedSuccess(
            updatedProfile: (state as ProfileLoaded).userProfile,
          ));
        }
      },
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
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}

