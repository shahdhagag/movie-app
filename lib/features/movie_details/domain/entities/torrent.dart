class Torrent {
  final String url;
  final String hash;
  final String quality;
  final String type;
  final int seeds;
  final int peers;
  final String size;
  final String dateUploaded;

  Torrent({
    required this.url,
    required this.hash,
    required this.quality,
    required this.type,
    required this.seeds,
    required this.peers,
    required this.size,
    required this.dateUploaded,
  });

  String get magnetUrl {
    final encodedTitle = Uri.encodeComponent(quality);
    return 'magnet:?xt=urn:btih:$hash'
        '&dn=$encodedTitle'
        '&tr=udp://glotorrents.pw:6969/announce'
        '&tr=udp://tracker.opentrackr.org:1337/announce'
        '&tr=udp://torrent.gresille.org:80/announce'
        '&tr=udp://tracker.openbittorrent.com:80'
        '&tr=udp://tracker.coppersurfer.tk:6969'
        '&tr=udp://tracker.leechers-paradise.org:6969'
        '&tr=udp://p4p.arenabg.ch:1337'
        '&tr=udp://tracker.internetwarriors.net:1337';
  }
}

