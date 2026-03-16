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

  MovieItem copyWith({
    int? movieId,
    String? title,
    String? posterPath,
    DateTime? addedAt,
  }) {
    return MovieItem(
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [movieId, title, posterPath, addedAt];
}