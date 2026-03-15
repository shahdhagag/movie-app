import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/google_sign_in_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart' as auth_logout;
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/browse/presentation/cubit/browse_cubit.dart';
import '../../features/home/data/dataSource/movie_remote_data_source.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_movies.dart';
import '../../features/home/domain/usecases/get_movies_by_genre.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/movie_details/data/dataSource/movie_details_remote_data_source.dart';
import '../../features/movie_details/data/repositories/movie_details_repository_impl.dart';
import '../../features/movie_details/domain/repositories/movie_details_repository.dart';
import '../../features/movie_details/domain/usecases/get_movie_details.dart';
import '../../features/movie_details/domain/usecases/get_movie_suggestions.dart';
import '../../features/movie_details/presentation/bloc/movie_details_bloc.dart';
import '../../features/search/data/dataSourses/search_remote_data_source.dart';
import '../../features/search/data/reposatories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repo.dart';
import '../../features/search/domain/usecases/search_movies_usecase.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/domain/usecases/get_watchlist.dart';
import '../../features/profile/domain/usecases/get_history.dart';
import '../../features/profile/domain/usecases/add_to_watchlist.dart';
import '../../features/profile/domain/usecases/add_to_history.dart';
import '../../features/profile/domain/usecases/remove_from_watchlist.dart';
import '../../features/profile/domain/usecases/update_user_profile.dart';
import '../../features/profile/domain/usecases/is_movie_in_watchlist.dart';
import '../../features/profile/domain/usecases/is_movie_in_history.dart';
import '../../features/profile/domain/usecases/logout.dart' as profile_logout;
import '../../features/profile/domain/usecases/delete_account.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/dio_client.dart';

final getIt = GetIt.instance;
const String _googleWebClientId =
    '370713648945-c5cfi1sa0j62clf5c0mjuq9bp3h95aae.apps.googleusercontent.com';

Future<void> setupLocator() async {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton(() => getIt<DioClient>().dio);

  // ==================== AUTH FEATURE ====================

  // Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      googleWebClientId: _googleWebClientId,
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<auth_logout.LogoutUseCase>(
    () => auth_logout.LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepository>()),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<auth_logout.LogoutUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      googleSignInUseCase: getIt<GoogleSignInUseCase>(),
    ),
  );

  // ==================== HOME FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: getIt<MovieRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetMovies>(
    () => GetMovies(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetMoviesByGenre>(
    () => GetMoviesByGenre(getIt<MovieRepository>()),
  );

  // BLoCs
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMovies: getIt<GetMovies>(),
      getMoviesByGenre: getIt<GetMoviesByGenre>(),
    ),
  );

  // ==================== BROWSE FEATURE ====================

  // Cubits
  getIt.registerFactory<BrowseCubit>(
    () => BrowseCubit(getIt<GetMoviesByGenre>()),
  );

  // ==================== MOVIE DETAILS FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<MovieDetailsRemoteDataSource>(
    () => MovieDetailsRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieDetailsRepository>(
    () => MovieDetailsRepositoryImpl(
      remoteDataSource: getIt<MovieDetailsRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetMovieDetails>(
    () => GetMovieDetails(getIt<MovieDetailsRepository>()),
  );
  getIt.registerLazySingleton<GetMovieSuggestions>(
    () => GetMovieSuggestions(getIt<MovieDetailsRepository>()),
  );

  // BLoCs
  getIt.registerFactory<MovieDetailsBloc>(
    () => MovieDetailsBloc(
      getMovieDetails: getIt<GetMovieDetails>(),
      getMovieSuggestions: getIt<GetMovieSuggestions>(),
    ),
  );

  // ==================== SEARCH FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: getIt<SearchRemoteDataSource>(),
    ),
  );

  // UseCases
  getIt.registerLazySingleton<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(
      repository: getIt<SearchRepository>(),
    ),
  );

  // Cubit
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      searchMoviesUseCase: getIt<SearchMoviesUseCase>(),
    ),
  );

  // ==================== PROFILE FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: getIt<ProfileRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetWatchListUseCase>(
    () => GetWatchListUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetHistoryUseCase>(
    () => GetHistoryUseCase(getIt<ProfileRepository>()),
  );

  // Helper Use Cases
  getIt.registerLazySingleton<IsMovieInWatchListUseCase>(
    () => IsMovieInWatchListUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<IsMovieInHistoryUseCase>(
    () => IsMovieInHistoryUseCase(getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<profile_logout.LogoutUseCase>(
    () => profile_logout.LogoutUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<ProfileRepository>()),
  );

  // New Profile Use Cases
  getIt.registerLazySingleton<AddToWatchListUseCase>(
    () => AddToWatchListUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<RemoveFromWatchListUseCase>(
    () => RemoveFromWatchListUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<AddToHistoryUseCase>(
    () => AddToHistoryUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(getIt<ProfileRepository>()),
  );

  // BLoCs
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      getWatchListUseCase: getIt<GetWatchListUseCase>(),
      getHistoryUseCase: getIt<GetHistoryUseCase>(),
      logoutUseCase: getIt<profile_logout.LogoutUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
      addToWatchListUseCase: getIt<AddToWatchListUseCase>(),
      addToHistoryUseCase: getIt<AddToHistoryUseCase>(),
      updateUserProfileUseCase: getIt<UpdateUserProfileUseCase>(),
    ),
  );
}
