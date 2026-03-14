import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_item.dart';
import '../repositories/profile_repository.dart';

class GetWatchListStreamUseCase extends UseCase<Stream<Either<Failure, List<MovieItem>>>, NoParams> {
  final ProfileRepository repository;

  GetWatchListStreamUseCase(this.repository);

  @override
  Stream<Either<Failure, List<MovieItem>>> call(NoParams params) {
    return repository.getWatchListStream();
  }
}

