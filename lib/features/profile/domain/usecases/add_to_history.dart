import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class AddToHistoryUseCase extends UseCase<void, AddToHistoryParams> {
  final ProfileRepository repository;

  AddToHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToHistoryParams params) async {
    return await repository.addToHistory(
      movieId: params.movieId,
      title: params.title,
      posterPath: params.posterPath,
    );
  }
}

class AddToHistoryParams extends Equatable {
  final int movieId;
  final String title;
  final String posterPath;

  const AddToHistoryParams({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath];
}

