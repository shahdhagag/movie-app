import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies({
    required int page,
    required int limit,
  });

  Future<List<MovieModel>> getMoviesByGenre({
    required String genre,
    int page = 1,
    int limit = 20,
  });
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getMovies({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        EndPoints.listMovies,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if status is ok
        if (responseData['status'] != 'ok') {
          throw ServerException(
            message: responseData['status_message'] ?? 'Unknown error',
            statusCode: response.statusCode,
          );
        }

        final data = responseData['data'];

        if (data == null) {
          throw ServerException(
            message: 'No data in response',
            statusCode: response.statusCode,
          );
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
          message: 'Failed to fetch movies',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      } else {
        throw ServerException(
          message: e.message ?? 'Network error occurred',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre({
    required String genre,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        EndPoints.listMovies,
        queryParameters: {
          'page': page,
          'limit': limit,
          'genre': genre,
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

        if (data == null) {
          throw ServerException(
            message: 'No data in response',
            statusCode: response.statusCode,
          );
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
          message: 'Failed to fetch movies by genre',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      } else {
        throw ServerException(
          message: e.message ?? 'Network error occurred',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }
}