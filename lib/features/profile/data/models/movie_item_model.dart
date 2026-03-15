import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_item.dart';

class MovieItemModel extends Equatable {
  final int movieId;
  final String title;
  final String posterPath;
  final DateTime addedAt;

  const MovieItemModel({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.addedAt,
  });

  factory MovieItemModel.fromJson(Map<String, dynamic> json) {
    return MovieItemModel(
      movieId: json['movieId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['posterPath'] as String? ?? '',
      addedAt: json['addedAt'] != null 
          ? DateTime.parse(json['addedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'movieId': movieId,
    'title': title,
    'posterPath': posterPath,
    'addedAt': addedAt.toIso8601String(),
  };

  MovieItem toEntity() {
    return MovieItem(
      movieId: movieId,
      title: title,
      posterPath: posterPath,
      addedAt: addedAt,
    );
  }

  @override
  List<Object?> get props => [movieId, title, posterPath, addedAt];
}

