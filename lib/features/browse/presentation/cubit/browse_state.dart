
import '../../../home/domain/entities/movie.dart';

abstract class BrowseState {
  final String selectedGenre;
  BrowseState(this.selectedGenre);
}

class BrowseInitial extends BrowseState {
  BrowseInitial(super.selectedGenre);
}

class BrowseLoading extends BrowseState {
  BrowseLoading(super.selectedGenre);
}

class BrowseLoaded extends BrowseState {
  final List<Movie> movies;
  BrowseLoaded(this.movies, super.selectedGenre);
}

class BrowseError extends BrowseState {
  final String message;
  BrowseError(this.message, super.selectedGenre);
}