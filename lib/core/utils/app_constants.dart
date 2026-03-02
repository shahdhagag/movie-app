/// App Constants
/// App Constants
class AppConstants {
  AppConstants._(); // prevent instantiation

  // API
  static const String baseUrl = 'https://movies-api.accel.li/api/v2';
  static const String apiKey = '--';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPage = 1;
  static const int defaultLimit = 50;


  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 3;
  static const int maxNameLength = 50;

}

