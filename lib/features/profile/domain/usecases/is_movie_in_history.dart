import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class IsMovieInHistoryUseCase {
  final ProfileRepository repository;

  IsMovieInHistoryUseCase(this.repository);

  Future<Either<Failure, bool>> call({required int movieId}) async {
    return await repository.isMovieInHistory(movieId: movieId);
  }
}



