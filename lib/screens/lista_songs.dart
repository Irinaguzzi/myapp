import 'package:flutter/material.dart';
import 'package:myapp/datasource/songs.dart'; // Importa la lista de canciones

class ListaSongs extends StatelessWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context) {
    // Divide las 14 canciones en dos listas de 7
    final leftColumn = songs.sublist(0, 7);
    final rightColumn = songs.sublist(7, 14);
    final pairedSongs = List.generate(7, (index) => [leftColumn[index], rightColumn[index]]);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),

          // Capa oscura encima para mejor contraste
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
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'My Playlist',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Lista sin scroll, con tarjetas más compactas
                Expanded(
                  child: ListView.builder(
                    itemCount: pairedSongs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final pair = pairedSongs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), // Menor espacio vertical
                        child: Row(
                          children: pair.map((song) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  color: Colors.grey[900]?.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 68, // Más bajo que antes
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      leading: song.posterUrl != null && song.posterUrl!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.network(
                                                song.posterUrl!,
                                                width: 44,
                                                height: 44,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.music_note,
                                              color: Colors.white,
                                              size: 36,
                                            ),
                                      title: Text(
                                        song.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${song.singer} (${song.year})',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
