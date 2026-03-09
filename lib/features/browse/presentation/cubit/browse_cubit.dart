import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/usecases/get_movies_by_genre.dart';
import 'browse_state.dart';
class BrowseCubit extends Cubit<BrowseState> {
  final GetMoviesByGenre getMoviesByGenre;

  BrowseCubit(this.getMoviesByGenre) : super(BrowseInitial("action"));

  Future<void> loadMovies({required String genre, int page = 1}) async {
    emit(BrowseLoading(genre));

    final result = await getMoviesByGenre(GenreParams(genre: genre, page: page));

    result.fold(
          (failure) => emit(BrowseError(failure.message, genre)),
          (movies) => emit(BrowseLoaded(movies, genre)),
    );
  }
}