import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/domain/class.dart';
import 'package:myapp/datasource/songs.dart'; // importo las canciones iniciales

// provider para manejar lista de canciones en toda la app
final songsProvider = StateProvider<List<Song>>((ref) => songs);
