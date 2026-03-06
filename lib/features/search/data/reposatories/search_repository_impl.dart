import '../../domain/entities/movie.dart';
import '../../domain/repositories/search_repo.dart';
import '../dataSourses/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    int limit = 20,
  }) {
    return remoteDataSource.searchMovies(
      query: query,
      page: page,
      limit: limit,
    );
  }
}