import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class IsMovieInHistoryUseCase extends UseCase<Future<Either<Failure, bool>>, IsMovieInHistoryParams> {
  final ProfileRepository repository;

  IsMovieInHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsMovieInHistoryParams params) async {
    return await repository.isMovieInHistory(movieId: params.movieId);
  }
}

class IsMovieInHistoryParams {
  final int movieId;

  IsMovieInHistoryParams({required this.movieId});
}

