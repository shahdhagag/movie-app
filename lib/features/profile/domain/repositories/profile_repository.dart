import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_item.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();

  Future<Either<Failure, void>> updateUserProfile({
    required String displayName,
    required String phoneNumber,
    String? bio,
    String? photoUrl,
  });

  Future<Either<Failure, List<MovieItem>>> getWatchList();

  Future<Either<Failure, List<MovieItem>>> getHistory();

  // Stream-based methods for real-time updates
  Stream<Either<Failure, List<MovieItem>>> getWatchListStream();

  Stream<Either<Failure, List<MovieItem>>> getHistoryStream();

  Stream<Either<Failure, UserProfile>> getUserProfileStream();

  Future<Either<Failure, void>> addToWatchList({
    required int movieId,
    required String title,
    required String posterPath,
  });

  Future<Either<Failure, void>> addToHistory({
    required int movieId,
    required String title,
    required String posterPath,
  });

  Future<Either<Failure, void>> removeFromWatchList({required int movieId});

  Future<Either<Failure, void>> removeFromHistory({required int movieId});

  Future<Either<Failure, bool>> isMovieInWatchList({required int movieId});

  Future<Either<Failure, bool>> isMovieInHistory({required int movieId});

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> logout();
}


