import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase extends UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await repository.updateUserProfile(
      displayName: params.displayName,
      phoneNumber: params.phoneNumber,
      bio: params.bio,
      photoUrl: params.photoUrl,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String displayName;
  final String phoneNumber;
  final String? bio;
  final String? photoUrl;

  const UpdateProfileParams({
    required this.displayName,
    required this.phoneNumber,
    this.bio,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, bio, photoUrl];
}


