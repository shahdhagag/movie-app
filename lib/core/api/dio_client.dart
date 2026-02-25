import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../utils/app_constants.dart';

/// Dio Client for API calls
@singleton
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

  }

  Dio get dio => _dio;


}


