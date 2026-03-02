import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../dataSource/movie_details_remote_data_source.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDataSource remoteDataSource;

  MovieDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails({required int movieId}) async {
    try {
      final movieDetails = await remoteDataSource.getMovieDetails(movieId: movieId);
      return Right(movieDetails);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieSuggestions({required int movieId}) async {
    try {
      final suggestions = await remoteDataSource.getMovieSuggestions(movieId: movieId);
      return Right(suggestions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const ServerFailure('Unexpected error occurred'));
    }
  }
}

