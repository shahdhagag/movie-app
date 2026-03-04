import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const LoadMovieDetails({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

