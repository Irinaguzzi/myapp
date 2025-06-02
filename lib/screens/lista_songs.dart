import 'package:flutter/material.dart';
import 'package:myapp/datasource/songs.dart'; // Importa la lista de canciones desde otro archivo

class ListaSongs extends StatelessWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context) {
    // Divide la lista de canciones en dos columnas de 7 canciones cada una
    final leftColumn = songs.sublist(0, 7);   // Canciones del 0 al 6
    final rightColumn = songs.sublist(7, 14); // Canciones del 7 al 13

    // Agrupa las canciones en pares (una de la izquierda y una de la derecha)
    final pairedSongs = List.generate(7, (index) => [leftColumn[index], rightColumn[index]]);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen que cubre toda la pantalla
          Positioned.fill(
            child: Image.network(
              'https://img.pikbest.com/wp/202344/background-violet-deep-textured_9933699.jpg!w700wp',
              fit: BoxFit.cover, // Ajusta la imagen para que cubra todo el fondo
            ),
          ),

          // Capa oscura encima para mejorar contraste del contenido
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(153, 0, 0, 0), // Opacidad del 60%
            ),
          ),

          // Contenido principal (título + lista)
          SafeArea(
            child: Column(
              children: [
                // Título de la playlist
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

                // Lista de canciones en 2 columnas
                Expanded(
                  child: ListView.builder(
                    itemCount: pairedSongs.length, // 7 filas
                    physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll
                    itemBuilder: (context, index) {
                      final pair = pairedSongs[index]; // Par de canciones

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: pair.map((song) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Card(
                                  color: Colors.grey[900]?.withOpacity(0.8), // Fondo oscuro con opacidad
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SizedBox(
                                    height: 80, // Altura de cada tarjeta
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      
                                      // Imagen de la canción (o ícono alternativo)
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
                                      
                                      // Título de la canción
                                      title: Text(
                                        song.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),

                                      // Artista y año
                                      subtitle: Text(
                                        '${song.singer} (${song.year})',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(), // Convierte el par de canciones en widgets
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
