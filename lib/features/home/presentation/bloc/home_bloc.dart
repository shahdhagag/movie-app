import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/get_movies_by_genre.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMovies getMovies;
  final GetMoviesByGenre getMoviesByGenre;

  HomeBloc({required this.getMovies, required this.getMoviesByGenre})
      : super(HomeInitial()) {
    on<LoadMovies>(_onLoadMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    // Fetch featured movies
    final result = await getMovies(
      MovieParams(page: event.page, limit: event.limit),
    );

    await result.fold(
      (failure) async => emit(HomeError(message: failure.message)),
      (movies) async {
        if (movies.isEmpty) {
          emit(const HomeError(message: 'No movies found'));
          return;
        }

        // Fetch genre-specific movies in parallel
        final results = await Future.wait([
          getMoviesByGenre(const GenreParams(genre: 'action', limit: 20)),
          getMoviesByGenre(const GenreParams(genre: 'adventure', limit: 20)),
          getMoviesByGenre(const GenreParams(genre: 'animation', limit: 20)),
        ]);

        final actionMovies = results[0].fold((_) => movies, (m) => m);
        final adventureMovies = results[1].fold((_) => movies, (m) => m);
        final animationMovies = results[2].fold((_) => movies, (m) => m);

        emit(HomeLoaded(
          movies: movies,
          actionMovies: actionMovies,
          adventureMovies: adventureMovies,
          animationMovies: animationMovies,
        ));
      },
    );
  }
}