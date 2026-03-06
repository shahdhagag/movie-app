import '../entities/movie.dart';
import '../repositories/search_repo.dart';

class SearchMoviesUseCase {
  final SearchRepository repository;

  SearchMoviesUseCase({required this.repository});

  Future<List<Movie>> call({
    required String query,
    int page = 1,
    int limit = 20,
  }) {
    return repository.searchMovies(
      query: query,
      page: page,
      limit: limit,
    );
  }
}