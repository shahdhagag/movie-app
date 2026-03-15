import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class RemoveFromWatchListUseCase
    extends UseCase<void, RemoveFromWatchListParams> {
  final ProfileRepository repository;

  RemoveFromWatchListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWatchListParams params) async {
    return repository.removeFromWatchList(movieId: params.movieId);
  }
}

class RemoveFromWatchListParams extends Equatable {
  final int movieId;

  const RemoveFromWatchListParams({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}
