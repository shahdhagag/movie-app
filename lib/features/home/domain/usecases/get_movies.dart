import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_constants.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovies implements UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) {
    return repository.getMovies(
      page: params.page,
      limit: params.limit,
    );
  }
}

class MovieParams {
  final int page;
  final int limit;

  const MovieParams({
    this.page = AppConstants.defaultPage,
    this.limit = AppConstants.defaultLimit,
  });
}