class Song {
  final String id;
  final String title;
  final String singer;
  final int year;
  final String? posterUrl;
  final String? lyric;

  Song({
    required this.id,
    required this.title,
    required this.singer,
    required this.year,
    this.posterUrl,
    this.lyric,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'director': singer,
      'year': year,
      'posterUrl': posterUrl,
      'lyrics': lyric,
    };
  }
}
