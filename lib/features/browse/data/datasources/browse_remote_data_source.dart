import 'package:dio/dio.dart';
import '../models/movie_model.dart';

abstract class BrowseRemoteDataSource {
  Future<List<MovieModel>> getMoviesByGenre(int genreId);
}

class BrowseRemoteDataSourceImpl implements BrowseRemoteDataSource {
  final Dio dio;

  BrowseRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final response = await dio.get(
      "/discover/movie",
      queryParameters: {
        "with_genres": genreId,
      },
    );

    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
}