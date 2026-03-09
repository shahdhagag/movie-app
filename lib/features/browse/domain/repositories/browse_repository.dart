import '../entities/movie.dart';

abstract class BrowseRepository {
  Future<List<Movie>> getMoviesByGenre(int genreId);
}