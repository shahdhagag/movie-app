import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// The [GoogleSignInUseCase] class is a use case for signing in with Google.
///
/// This use case interacts with the [AuthRepository] to perform Google sign-in and returns
/// either a [Failure] or an [AuthUser] entity wrapped in an [Either] type from the dartz package.
///
/// Example usage:
/// ```dart
/// final useCase = GoogleSignInUseCase(authRepository);
/// final result = await useCase(NoParams());
/// ```
class GoogleSignInUseCase implements UseCase<AuthUser, NoParams> {
  /// The authentication repository used to perform Google sign-in.
  final AuthRepository repository;

  /// Creates a [GoogleSignInUseCase] with the given [repository].
  GoogleSignInUseCase(this.repository);

  /// Calls the Google sign-in method on the repository.
  ///
  /// Returns a [Future] of [Either] containing a [Failure] or an [AuthUser].
  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}

/// An empty parameter class used for use cases that do not require any parameters.
class NoParams {}
