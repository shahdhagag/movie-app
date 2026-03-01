import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.rating,
    required super.coverImage,
    super.backgroundImage,
    required super.year,
    required super.genres,
    super.summary,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      coverImage: json['medium_cover_image'] as String? ?? '',
      backgroundImage: json['background_image'] as String?,
      year: json['year'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      summary: json['summary'] as String?,
    );
  }
}