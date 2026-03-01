class Movie {
  final int id;
  final String title;
  final double rating;
  final String coverImage;
  final String? backgroundImage;
  final int year;
  final List<String> genres;
  final String? summary;

  Movie({
    required this.id,
    required this.title,
    required this.rating,
    required this.coverImage,
    this.backgroundImage,
    required this.year,
    required this.genres,
    this.summary,
  });
}