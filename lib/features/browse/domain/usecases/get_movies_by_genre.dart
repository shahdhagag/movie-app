import '../entities/movie.dart';
import '../repositories/browse_repository.dart';

class GetMoviesByGenre {
  final BrowseRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> call(int genreId) {
    return repository.getMoviesByGenre(genreId);
  }
}