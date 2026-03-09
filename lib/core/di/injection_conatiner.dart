import 'package:get_it/get_it.dart';
import '../../features/browse/data/datasources/browse_remote_data_source.dart';
import '../../features/browse/data/repositories/browse_repository_impl.dart';
import '../../features/browse/domain/repositories/browse_repository.dart';
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
import '../api/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton(() => getIt<DioClient>().dio);

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
// UseCase
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

// ==================== BROWSE FEATURE ====================



  // Data Sources
  getIt.registerLazySingleton<BrowseRemoteDataSource>(
        () => BrowseRemoteDataSourceImpl(getIt()),
  );

// Repositories
  getIt.registerLazySingleton<BrowseRepository>(
        () => BrowseRepositoryImpl(
      getIt<BrowseRemoteDataSource>(),
    ),
  );

// // UseCases
//   getIt.registerLazySingleton<GetMoviesByGenre>(
//         () => GetMoviesByGenre(getIt<MovieRepository>()),
//   );

// Cubit
  getIt.registerFactory<BrowseCubit>(
        () => BrowseCubit(getIt<GetMoviesByGenre>()),
  );
}

