import 'cast.dart';
import 'torrent.dart';

class MovieDetails {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final List<String> genres;
  final String? summary;
  final String? descriptionFull;
  final String? ytTrailerCode;
  final String? language;
  final String? backgroundImage;
  final String? backgroundImageOriginal;
  final String? smallCoverImage;
  final String? mediumCoverImage;
  final String? largeCoverImage;
  final String? mediumScreenshotImage1;
  final String? mediumScreenshotImage2;
  final String? mediumScreenshotImage3;
  final String? largeScreenshotImage1;
  final String? largeScreenshotImage2;
  final String? largeScreenshotImage3;
  final int likeCount;
  final int downloadCount;
  final List<Torrent> torrents;
  final List<Cast> cast;

  MovieDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    this.summary,
    this.descriptionFull,
    this.ytTrailerCode,
    this.language,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.mediumScreenshotImage1,
    this.mediumScreenshotImage2,
    this.mediumScreenshotImage3,
    this.largeScreenshotImage1,
    this.largeScreenshotImage2,
    this.largeScreenshotImage3,
    required this.likeCount,
    required this.downloadCount,
    required this.torrents,
    required this.cast,
  });
}

