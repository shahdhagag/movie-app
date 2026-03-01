import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByGenre implements UseCase<List<Movie>, GenreParams> {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GenreParams params) {
    return repository.getMoviesByGenre(
      genre: params.genre,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GenreParams {
  final String genre;
  final int page;
  final int limit;

  const GenreParams({
    required this.genre,
    this.page = 1,
    this.limit = 20,
  });
}

