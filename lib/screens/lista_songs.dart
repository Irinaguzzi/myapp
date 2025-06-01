import 'package:flutter/material.dart';
import 'package:myapp/datasource/songs.dart'; // Importás la lista de canciones

class ListaSongs extends StatelessWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Canciones'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: song.posterUrl != null
                ? Image.network(song.posterUrl!)
                : const Icon(Icons.music_note),
            title: Text(song.title),
            subtitle: Text('${song.singer} (${song.year})'),
          );
        },
      ),
    );
  }
}
