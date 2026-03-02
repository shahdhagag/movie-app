import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, List<Movie>>> getMoviesByGenre({
    required String genre,
    int page = 1,
    int limit = 20,
  });
}