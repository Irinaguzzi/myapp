import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/datasource/user.dart';
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

final usersProvider =
    StateNotifierProvider<UsersNotifier, List<User>>((ref) {
  return UsersNotifier(FirebaseFirestore.instance);
});

class UsersNotifier extends StateNotifier<List<User>> {
  final FirebaseFirestore db;
  UsersNotifier(this.db) : super([]);

  Future<void> addUser(User user) async {
    final doc = db.collection('users').doc();
    final newUser = User(
      id: doc.id,
      username: user.username,
      password: user.password,
    );
    try {
      await doc.set(newUser.toFirestore());
      state = [...state, newUser];
    } catch (e) {
      print("Error al agregar usuario: $e");
    }
  }

  Future<void> getAllUsers() async {
    try {
      final snapshot = await db.collection('users').get();
      state = snapshot.docs
          .map((doc) => User.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error al traer usuarios: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await db.collection('users').doc(id).delete();
      state = state.where((u) => u.id != id).toList();
    } catch (e) {
      print("Error al borrar usuario: $e");
    }
  }
}
