import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_movie_suggestions.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  final GetMovieSuggestions getMovieSuggestions;

  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getMovieSuggestions,
  }) : super(MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    final detailsResult = await getMovieDetails(
      MovieDetailsParams(movieId: event.movieId),
    );

    await detailsResult.fold(
      (failure) async => emit(MovieDetailsError(message: failure.message)),
      (movieDetails) async {
        // Fetch suggestions in parallel
        final suggestionsResult = await getMovieSuggestions(
          MovieSuggestionsParams(movieId: event.movieId),
        );

        final suggestions = suggestionsResult.fold(
          (_) => <dynamic>[],
          (movies) => movies,
        );

        emit(MovieDetailsLoaded(
          movieDetails: movieDetails,
          suggestions: List.from(suggestions),
        ));
      },
    );
  }
}

