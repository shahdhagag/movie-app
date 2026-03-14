import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class IsMovieInWatchListUseCase {
  final ProfileRepository repository;

  IsMovieInWatchListUseCase(this.repository);

  Future<Either<Failure, bool>> call({required int movieId}) async {
    return await repository.isMovieInWatchList(movieId: movieId);
  }
}



