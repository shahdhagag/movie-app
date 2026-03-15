import 'package:equatable/equatable.dart';

class MovieItem extends Equatable {
  final int movieId;
  final String title;
  final String posterPath;
  final DateTime addedAt;

  const MovieItem({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath, addedAt];
}


