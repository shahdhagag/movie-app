import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthUser>> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String photoUrl,
  }) async {
    try {
      final user = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Failed to send reset email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail() async {
    try {
      await remoteDataSource.verifyEmail();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Failed to verify email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String displayName,
    required String? photoUrl,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure('Google sign in failed: ${e.toString()}'));
    }
  }
}
