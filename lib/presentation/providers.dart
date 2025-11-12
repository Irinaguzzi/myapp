import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// alias para evitar q se confunda con LocalUser
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:myapp/datasource/local_user.dart';  
import 'package:myapp/domain/class.dart';


// ----------------------- SONGS PROVIDER -----------------------


final songsProvider =
    StateNotifierProvider<SongsNotifier, List<Song>>((ref) {
  return SongsNotifier(FirebaseFirestore.instance);
});


class SongsNotifier extends StateNotifier<List<Song>> {
  final FirebaseFirestore db;


  StreamSubscription<fb_auth.User?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _songsSub;


  SongsNotifier(this.db) : super([]) {
    // escuchar cambios de autenticación para (re)configurar la suscripcion a canciones
    _authSub = fb_auth.FirebaseAuth.instance.authStateChanges().listen((fb_auth.User? user) {
      _songsSub?.cancel();


      if (user == null) {
        // usuario no logueado -> lista vacía
        state = [];
      } else {
        // suscribirse a la colección personal del usuario en tiempo real
        final userSongsRef = db.collection('users').doc(user.uid).collection('songs').orderBy('createdAt', descending: true);


        _songsSub = userSongsRef.snapshots().listen((snapshot) {
          state = snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
        }, onError: (e) {
          print("Error escuchando canciones del usuario: $e");
          state = [];
        });
      }
    });
  }

  Future<void> getAllSongsOnce() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = [];
      return;
    }
    try {
      final snapshot = await db.collection('users').doc(user.uid).collection('songs').get();
      state = snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error al obtener canciones: $e");
    }
  }


  // agregar canción SOLO en la colección del usuario actual
  Future<void> addSong(Song song) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");


    try {
      final docRef = db.collection('users').doc(user.uid).collection('songs').doc();
      final newSong = Song(
        id: docRef.id,
        title: song.title,
        singer: song.singer,
        year: song.year,
        posterUrl: song.posterUrl,
        lyric: song.lyric,
      );
      await docRef.set({
        ...newSong.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': user.uid, 
      });
      // el listener de snapshots va a actualizar "state" automáticamente
    } catch (e) {
      print("Error al agregar canción en user collection: $e");
    }
  }


  Future<void> updateSong(Song song) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");


    try {
      await db.collection('users').doc(user.uid).collection('songs').doc(song.id).update({
        ...song.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // listener va a actualizar el estado
    } catch (e) {
      print("Error al actualizar canción: $e");
    }
  }


  Future<void> deleteSong(String id) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");
    try {
      await db.collection('users').doc(user.uid).collection('songs').doc(id).delete();
      // listener va a actualizar el estado
    } catch (e) {
      print("Error al borrar canción: $e");
    }
  }


  // ---------------- Migration ----------------
  // Mueve canciones de la colección global 'songs' a users/{uid}/songs
  // Si los documentos en 'songs' tienen un campo 'createdBy' con UID, las moverá
  // Si no lo tienen, las ignorará (para evitar reasignar sin criterio)
  Future<void> migrateGlobalSongsToUserCollections({bool moveIfNoOwner = false}) async {
    try {
      final global = await db.collection('songs').get();
      for (final doc in global.docs) {
        final data = doc.data();
        final owner = data['createdBy'] as String?;
        if (owner != null && owner.isNotEmpty) {
          final targetRef = db.collection('users').doc(owner).collection('songs').doc(doc.id);
          await targetRef.set({
            ...data,
            'migratedAt': FieldValue.serverTimestamp(),
          });
          // opcional: borrar original
          await doc.reference.delete();
        } else if (moveIfNoOwner) {
          final targetRef = db.collection('users').doc('orphan').collection('songs').doc(doc.id);
          await targetRef.set({...data, 'migratedAt': FieldValue.serverTimestamp()});
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print("Error migrando canciones globales: $e");
    }
  }


  @override
  void dispose() {
    _authSub?.cancel();
    _songsSub?.cancel();
    super.dispose();
  }
}


// ----------------------- USERS PROVIDER -----------------------


final usersProvider =
    StateNotifierProvider<UsersNotifier, List<LocalUser>>((ref) {
  return UsersNotifier(FirebaseFirestore.instance);
});


class UsersNotifier extends StateNotifier<List<LocalUser>> {
  final FirebaseFirestore db;


  UsersNotifier(this.db) : super([]);


  Future<void> addUser(LocalUser user) async {
    final doc = db.collection('users').doc();
    final newUser = LocalUser(
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
      state =
          snapshot.docs.map((doc) => LocalUser.fromFirestore(doc)).toList();
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



// ----------------------- LIKES PROVIDER -----------------------


final likesProvider =
    StateNotifierProvider<LikesNotifier, Set<String>>((ref) {
  return LikesNotifier(FirebaseFirestore.instance);
});


class LikesNotifier extends StateNotifier<Set<String>> {
  final FirebaseFirestore db;
  StreamSubscription<fb_auth.User?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _likesSub;


  LikesNotifier(this.db) : super({}) {
    _authSub = fb_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((fb_auth.User? user) {
      _likesSub?.cancel();


      if (user != null) {
        final likesRef =
            db.collection('users').doc(user.uid).collection('likes');


        _likesSub = likesRef.snapshots().listen((snapshot) {
          final ids = snapshot.docs.map((d) => d.id).toSet();
          state = ids;
        });
      } else {
        state = {};
      }
    });
  }


  Future<void> toggleLike(String songId) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return;


    final docRef =
        db.collection('users').doc(user.uid).collection('likes').doc(songId);


    if (state.contains(songId)) {
      await docRef.delete();
    } else {
      await docRef.set({'likedAt': FieldValue.serverTimestamp()});
    }
  }


  @override
  void dispose() {
    _authSub?.cancel();
    _likesSub?.cancel();
    super.dispose();
  }
}
