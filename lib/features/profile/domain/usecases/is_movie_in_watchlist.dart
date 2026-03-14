import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class IsMovieInWatchListUseCase extends UseCase<Future<Either<Failure, bool>>, IsMovieInWatchListParams> {
  final ProfileRepository repository;

  IsMovieInWatchListUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsMovieInWatchListParams params) async {
    return await repository.isMovieInWatchList(movieId: params.movieId);
  }
}

class IsMovieInWatchListParams {
  final int movieId;

  IsMovieInWatchListParams({required this.movieId});
}

