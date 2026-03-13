import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class AddToWatchListUseCase extends UseCase<void, AddToWatchListParams> {
  final ProfileRepository repository;

  AddToWatchListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToWatchListParams params) async {
    return await repository.addToWatchList(
      movieId: params.movieId,
      title: params.title,
      posterPath: params.posterPath,
    );
  }
}

class AddToWatchListParams extends Equatable {
  final int movieId;
  final String title;
  final String posterPath;

  const AddToWatchListParams({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath];
}

