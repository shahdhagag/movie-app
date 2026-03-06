import '../entities/movie.dart';

abstract class SearchRepository {
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    int limit = 20,
  });
}