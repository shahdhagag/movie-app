import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_item.dart';
import '../repositories/profile_repository.dart';

class GetWatchListUseCase extends UseCase<List<MovieItem>, NoParams> {
  final ProfileRepository repository;

  GetWatchListUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieItem>>> call(NoParams params) async {
    return await repository.getWatchList();
  }
}



