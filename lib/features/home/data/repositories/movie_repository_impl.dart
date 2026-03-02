import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_constants.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../dataSource/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getMovies({
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
  }) async {
    try {
      final movies = await remoteDataSource.getMovies(
        page: page,
        limit: limit,
      );
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre({
    required String genre,
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
  }) async {
    try {
      final movies = await remoteDataSource.getMoviesByGenre(
        genre: genre,
        page: page,
        limit: limit,
      );
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const ServerFailure('Unexpected error occurred'));
    }
  }
}