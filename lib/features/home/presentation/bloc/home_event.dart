import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends HomeEvent {
  final int page;
  final int limit;

  const LoadMovies({this.page = 1, this.limit = 20});

  @override
  List<Object> get props => [page, limit];
}