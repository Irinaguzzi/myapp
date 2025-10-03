import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/domain/class.dart';

// Provider que maneja toda la lógica de Firebase
final songsProvider =
    StateNotifierProvider<SongsNotifier, List<Song>>((ref) {
  return SongsNotifier(FirebaseFirestore.instance);
});

class SongsNotifier extends StateNotifier<List<Song>> {
  final FirebaseFirestore db;
  SongsNotifier(this.db) : super([]);

  // 🔹 Agregar canción
  Future<void> addSong(Song song) async {
    final doc = db.collection('songs').doc();
    final newSong = Song(
      id: doc.id,
      title: song.title,
      singer: song.singer,
      year: song.year,
      posterUrl: song.posterUrl,
      lyric: song.lyric,
    );
    try {
      await doc.set(newSong.toFirestore());
      state = [...state, newSong];
    } catch (e) {
      print("Error al agregar canción: $e");
    }
  }

  // 🔹 Traer todas las canciones
  Future<void> getAllSongs() async {
    try {
      final snapshot = await db.collection('songs').get();
      state = snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error al traer canciones: $e");
    }
  }

  // 🔹 Editar canción
  Future<void> updateSong(Song song) async {
    try {
      await db.collection('songs').doc(song.id).update(song.toFirestore());
      state = state.map((s) => s.id == song.id ? song : s).toList();
    } catch (e) {
      print("Error al actualizar canción: $e");
    }
  }

  // 🔹 Borrar canción
  Future<void> deleteSong(String id) async {
    try {
      await db.collection('songs').doc(id).delete();
      state = state.where((s) => s.id != id).toList();
    } catch (e) {
      print("Error al borrar canción: $e");
    }
  }
}
