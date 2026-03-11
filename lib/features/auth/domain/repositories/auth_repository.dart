import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  });

  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, AuthUser?>> getCurrentUser();

  Future<Either<Failure, void>> verifyEmail();

  Future<Either<Failure, void>> updateUserProfile({
    required String displayName,
    required String? photoUrl,
  });

  Future<Either<Failure, AuthUser>> signInWithGoogle();
}

