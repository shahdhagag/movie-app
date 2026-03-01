import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> movies;
  final List<Movie> actionMovies;
  final List<Movie> adventureMovies;
  final List<Movie> animationMovies;

  const HomeLoaded({
    required this.movies,
    this.actionMovies = const [],
    this.adventureMovies = const [],
    this.animationMovies = const [],
  });

  @override
  List<Object> get props => [movies, actionMovies, adventureMovies, animationMovies];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}