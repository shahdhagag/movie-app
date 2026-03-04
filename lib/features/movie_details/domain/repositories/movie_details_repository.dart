import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/movie.dart';
import '../entities/movie_details.dart';

abstract class MovieDetailsRepository {
  Future<Either<Failure, MovieDetails>> getMovieDetails({required int movieId});
  Future<Either<Failure, List<Movie>>> getMovieSuggestions({required int movieId});
}

