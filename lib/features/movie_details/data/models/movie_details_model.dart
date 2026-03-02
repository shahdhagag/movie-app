import '../../domain/entities/movie_details.dart';
import 'cast_model.dart';
import 'torrent_model.dart';

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.runtime,
    required super.genres,
    super.summary,
    super.descriptionFull,
    super.ytTrailerCode,
    super.language,
    super.backgroundImage,
    super.backgroundImageOriginal,
    super.smallCoverImage,
    super.mediumCoverImage,
    super.largeCoverImage,
    super.mediumScreenshotImage1,
    super.mediumScreenshotImage2,
    super.mediumScreenshotImage3,
    super.largeScreenshotImage1,
    super.largeScreenshotImage2,
    super.largeScreenshotImage3,
    required super.likeCount,
    required super.downloadCount,
    required super.torrents,
    required super.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      year: json['year'] as int? ?? 0,
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      runtime: json['runtime'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      summary: json['summary'] as String?,
      descriptionFull: json['description_full'] as String?,
      ytTrailerCode: json['yt_trailer_code'] as String?,
      language: json['language'] as String?,
      backgroundImage: json['background_image'] as String?,
      backgroundImageOriginal: json['background_image_original'] as String?,
      smallCoverImage: json['small_cover_image'] as String?,
      mediumCoverImage: json['medium_cover_image'] as String?,
      largeCoverImage: json['large_cover_image'] as String?,
      mediumScreenshotImage1: json['medium_screenshot_image1'] as String?,
      mediumScreenshotImage2: json['medium_screenshot_image2'] as String?,
      mediumScreenshotImage3: json['medium_screenshot_image3'] as String?,
      largeScreenshotImage1: json['large_screenshot_image1'] as String?,
      largeScreenshotImage2: json['large_screenshot_image2'] as String?,
      largeScreenshotImage3: json['large_screenshot_image3'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      downloadCount: json['download_count'] as int? ?? 0,
      torrents: (json['torrents'] as List<dynamic>?)
              ?.map((t) => TorrentModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      cast: (json['cast'] as List<dynamic>?)
              ?.map((c) => CastModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

