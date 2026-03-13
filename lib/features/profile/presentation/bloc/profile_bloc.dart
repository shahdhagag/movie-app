import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/delete_account.dart';
import '../../../../core/usecases/usecase.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetWatchListUseCase getWatchListUseCase;
  final GetHistoryUseCase getHistoryUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.getWatchListUseCase,
    required this.getHistoryUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  }) : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchWatchList>(_onFetchWatchList);
    on<FetchHistory>(_onFetchHistory);
    on<SwitchTabEvent>(_onSwitchTab);
    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

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
    final result = await getHistoryUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (history) => emit(HistoryLoaded(history: history)),
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

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
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
    final result = await deleteAccountUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}





