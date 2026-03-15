import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/movie_item.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = await remoteDataSource.getUserProfile();
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error fetching profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String displayName,
    required String phoneNumber,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        displayName: displayName,
        phoneNumber: phoneNumber,
        bio: bio,
        photoUrl: photoUrl,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error updating profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MovieItem>>> getWatchList() async {
    try {
      final models = await remoteDataSource.getWatchList();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error fetching watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MovieItem>>> getHistory() async {
    try {
      final models = await remoteDataSource.getHistory();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error fetching history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addToWatchList({
    required int movieId,
    required String title,
    required String posterPath,
  }) async {
    try {
      await remoteDataSource.addToWatchList(
        movieId: movieId,
        title: title,
        posterPath: posterPath,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error adding to watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addToHistory({
    required int movieId,
    required String title,
    required String posterPath,
  }) async {
    try {
      await remoteDataSource.addToHistory(
        movieId: movieId,
        title: title,
        posterPath: posterPath,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error adding to history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatchList({required int movieId}) async {
    try {
      await remoteDataSource.removeFromWatchList(movieId: movieId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error removing from watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromHistory({required int movieId}) async {
    try {
      await remoteDataSource.removeFromHistory(movieId: movieId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error removing from history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error deleting account: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error during logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isMovieInWatchList({required int movieId}) async {
    try {
      final result = await remoteDataSource.isMovieInWatchList(movieId: movieId);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error checking watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isMovieInHistory({required int movieId}) async {
    try {
      final result = await remoteDataSource.isMovieInHistory(movieId: movieId);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error checking history: ${e.toString()}'));
    }
  }
}

