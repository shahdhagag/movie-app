import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/services/auth_service.dart';
import '../api/dio_client.dart';

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

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton(() => getIt<DioClient>().dio);

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // AUTH FEATURE

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<auth_logout.LogoutUseCase>(() => auth_logout.LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase(getIt<AuthRepository>()));

  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
    loginUseCase: getIt<LoginUseCase>(),
    registerUseCase: getIt<RegisterUseCase>(),
    logoutUseCase: getIt<auth_logout.LogoutUseCase>(),
    forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
    googleSignInUseCase: getIt<GoogleSignInUseCase>(),
  ));

  // HOME FEATURE
  getIt.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(dio: getIt()));
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(remoteDataSource: getIt<MovieRemoteDataSource>()));
  getIt.registerLazySingleton<GetMovies>(() => GetMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton<GetMoviesByGenre>(() => GetMoviesByGenre(getIt<MovieRepository>()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getMovies: getIt<GetMovies>(), getMoviesByGenre: getIt<GetMoviesByGenre>()));
  getIt.registerFactory<BrowseCubit>(() => BrowseCubit(getIt<GetMoviesByGenre>()));

  // MOVIE DETAILS FEATURE
  getIt.registerLazySingleton<MovieDetailsRemoteDataSource>(() => MovieDetailsRemoteDataSourceImpl(dio: getIt()));
  getIt.registerLazySingleton<MovieDetailsRepository>(() => MovieDetailsRepositoryImpl(remoteDataSource: getIt<MovieDetailsRemoteDataSource>()));
  getIt.registerLazySingleton<GetMovieDetails>(() => GetMovieDetails(getIt<MovieDetailsRepository>()));
  getIt.registerLazySingleton<GetMovieSuggestions>(() => GetMovieSuggestions(getIt<MovieDetailsRepository>()));
  getIt.registerFactory<MovieDetailsBloc>(() => MovieDetailsBloc(getMovieDetails: getIt<GetMovieDetails>(), getMovieSuggestions: getIt<GetMovieSuggestions>()));

  //  SEARCH FEATURE
  getIt.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(dio: getIt()));
  getIt.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(remoteDataSource: getIt<SearchRemoteDataSource>()));
  getIt.registerLazySingleton<SearchMoviesUseCase>(() => SearchMoviesUseCase(repository: getIt<SearchRepository>()));
  getIt.registerFactory<SearchCubit>(() => SearchCubit(searchMoviesUseCase: getIt<SearchMoviesUseCase>()));

  //  PROFILE FEATURE
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(
    firestore: getIt<FirebaseFirestore>(),
    firebaseAuth: getIt<FirebaseAuth>(),
  ));

  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: getIt<ProfileRemoteDataSource>()));

  getIt.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<GetWatchListUseCase>(() => GetWatchListUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<GetHistoryUseCase>(() => GetHistoryUseCase(getIt<ProfileRepository>()));

  getIt.registerLazySingleton<IsMovieInWatchListUseCase>(() => IsMovieInWatchListUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<IsMovieInHistoryUseCase>(() => IsMovieInHistoryUseCase(getIt<ProfileRepository>()));

  getIt.registerLazySingleton<profile_logout.LogoutUseCase>(() => profile_logout.LogoutUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase(getIt<ProfileRepository>()));

  getIt.registerLazySingleton<AddToWatchListUseCase>(() => AddToWatchListUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<RemoveFromWatchListUseCase>(() => RemoveFromWatchListUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<AddToHistoryUseCase>(() => AddToHistoryUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<UpdateUserProfileUseCase>(() => UpdateUserProfileUseCase(getIt<ProfileRepository>()));

  getIt.registerLazySingleton<ProfileBloc>(() => ProfileBloc(
    getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
    getWatchListUseCase: getIt<GetWatchListUseCase>(),
    getHistoryUseCase: getIt<GetHistoryUseCase>(),
    logoutUseCase: getIt<profile_logout.LogoutUseCase>(),
    deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
    addToWatchListUseCase: getIt<AddToWatchListUseCase>(),
    removeFromWatchListUseCase: getIt<RemoveFromWatchListUseCase>(),
    addToHistoryUseCase: getIt<AddToHistoryUseCase>(),
    updateUserProfileUseCase: getIt<UpdateUserProfileUseCase>(),
  ));
}