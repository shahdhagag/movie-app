import '../../domain/entities/cast.dart';

class CastModel extends Cast {
  CastModel({
    required super.name,
    required super.characterName,
    super.urlSmallImage,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] as String? ?? 'Unknown',
      characterName: json['character_name'] as String? ?? '',
      urlSmallImage: json['url_small_image'] as String?,
    );
  }
}

