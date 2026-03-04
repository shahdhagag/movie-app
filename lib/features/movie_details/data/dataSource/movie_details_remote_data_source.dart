import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/movie_model.dart';
import '../models/movie_details_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails({required int movieId});
  Future<List<MovieModel>> getMovieSuggestions({required int movieId});
}

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final Dio dio;

  MovieDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    try {
      final response = await dio.get(
        EndPoints.movieDetails,
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] != 'ok') {
          throw ServerException(
            message: responseData['status_message'] ?? 'Unknown error',
            statusCode: response.statusCode,
          );
        }

        final data = responseData['data'];
        if (data == null || data['movie'] == null) {
          throw ServerException(
            message: 'No movie data in response',
            statusCode: response.statusCode,
          );
        }

        return MovieDetailsModel.fromJson(data['movie'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to fetch movie details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException(message: 'Connection timeout', statusCode: 408);
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(message: 'No internet connection', statusCode: null);
      } else {
        throw ServerException(
          message: e.message ?? 'Network error occurred',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions({required int movieId}) async {
    try {
      final response = await dio.get(
        EndPoints.movieSuggestions,
        queryParameters: {'movie_id': movieId},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] != 'ok') {
          throw ServerException(
            message: responseData['status_message'] ?? 'Unknown error',
            statusCode: response.statusCode,
          );
        }

        final data = responseData['data'];
        if (data == null) {
          return [];
        }

        final moviesList = data['movies'];
        if (moviesList == null || moviesList is! List) {
          return [];
        }

        return moviesList
            .map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch movie suggestions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException(message: 'Connection timeout', statusCode: 408);
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(message: 'No internet connection', statusCode: null);
      } else {
        throw ServerException(
          message: e.message ?? 'Network error occurred',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }
}

