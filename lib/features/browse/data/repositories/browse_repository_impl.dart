import '../../domain/entities/movie.dart';
import '../../domain/repositories/browse_repository.dart';
import '../datasources/browse_remote_data_source.dart';

class BrowseRepositoryImpl implements BrowseRepository {
  final BrowseRemoteDataSource remoteDataSource;

  BrowseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId) {
    return remoteDataSource.getMoviesByGenre(genreId);
  }
}