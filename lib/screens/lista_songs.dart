import 'package:flutter/material.dart';
import 'package:myapp/datasource/songs.dart'; // Importa la lista de canciones

class ListaSongs extends StatelessWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Positioned.fill(
            child: Image.network(
              'https://st2.depositphotos.com/1020070/11481/v/950/depositphotos_114813100-stock-illustration-black-and-white-musical-notation.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Capa oscura para contraste
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(153, 0, 0, 0), // 60% opacidad
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'My Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];

                      return Center(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.grey[900]?.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 80, // Cards más compactas
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              leading: song.posterUrl != null && song.posterUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        song.posterUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${song.singer} (${song.year})',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
