import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileStreamUseCase extends UseCase<Stream<Either<Failure, UserProfile>>, NoParams> {
  final ProfileRepository repository;

  GetUserProfileStreamUseCase(this.repository);

  @override
  Stream<Either<Failure, UserProfile>> call(NoParams params) {
    return repository.getUserProfileStream();
  }
}

