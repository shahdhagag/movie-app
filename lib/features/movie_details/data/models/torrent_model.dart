import '../../domain/entities/torrent.dart';

class TorrentModel extends Torrent {
  TorrentModel({
    required super.url,
    required super.hash,
    required super.quality,
    required super.type,
    required super.seeds,
    required super.peers,
    required super.size,
    required super.dateUploaded,
  });

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
      type: json['type'] as String? ?? '',
      seeds: json['seeds'] as int? ?? 0,
      peers: json['peers'] as int? ?? 0,
      size: json['size'] as String? ?? '',
      dateUploaded: json['date_uploaded'] as String? ?? '',
    );
  }
}
