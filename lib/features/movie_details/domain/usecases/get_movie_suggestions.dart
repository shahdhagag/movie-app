import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieSuggestions implements UseCase<List<Movie>, MovieSuggestionsParams> {
  final MovieDetailsRepository repository;

  GetMovieSuggestions(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieSuggestionsParams params) {
    return repository.getMovieSuggestions(movieId: params.movieId);
  }
}

class MovieSuggestionsParams {
  final int movieId;

  const MovieSuggestionsParams({required this.movieId});
}

