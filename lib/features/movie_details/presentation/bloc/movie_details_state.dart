import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movieDetails;
  final List<Movie> suggestions;

  const MovieDetailsLoaded({
    required this.movieDetails,
    this.suggestions = const [],
  });

  @override
  List<Object> get props => [movieDetails, suggestions];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

