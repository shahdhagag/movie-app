import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieDetails implements UseCase<MovieDetails, MovieDetailsParams> {
  final MovieDetailsRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, MovieDetails>> call(MovieDetailsParams params) {
    return repository.getMovieDetails(movieId: params.movieId);
  }
}

class MovieDetailsParams {
  final int movieId;

  const MovieDetailsParams({required this.movieId});
}

