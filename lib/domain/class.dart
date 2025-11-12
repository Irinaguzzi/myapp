import 'package:cloud_firestore/cloud_firestore.dart';


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


  factory Song.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Song(
      id: doc.id, // usa el id del documento como id unico
      title: data['title'] ?? '',
      singer: data['singer'] ?? '',
      year: data['year'] ?? 0,
      posterUrl: data['posterUrl'],
      lyric: data['lyric'],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'singer': singer,
      'year': year,
      'posterUrl': posterUrl,
      'lyric': lyric,
    };
  }
}
