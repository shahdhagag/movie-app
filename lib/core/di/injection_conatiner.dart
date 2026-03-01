import 'package:get_it/get_it.dart';
import '../../features/home/data/dataSource/movie_remote_data_source.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_movies.dart';
import '../../features/home/domain/usecases/get_movies_by_genre.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../api/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton(() => getIt<DioClient>().dio);

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

  // BLoCs - Factory (new instance each time)
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMovies: getIt<GetMovies>(),
      getMoviesByGenre: getIt<GetMoviesByGenre>(),
    ),
  );
}

