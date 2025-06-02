import 'package:flutter/material.dart';
import 'package:myapp/datasource/songs.dart'; // Importa la lista de canciones desde otro archivo

class ListaSongs extends StatelessWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen que cubre toda la pantalla
          Positioned.fill(
            child: Image.network(
              'https://st2.depositphotos.com/1020070/11481/v/950/depositphotos_114813100-stock-illustration-black-and-white-musical-notation.jpg',
              fit: BoxFit.cover, // La imagen se ajusta para cubrir todo
            ),
          ),
          // Capa oscura encima del fondo para mejorar el contraste con el contenido
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6), // Opacidad del 60%
            ),
          ),
          // Contenido principal de la pantalla
          SafeArea( // Asegura que el contenido no se meta debajo de la barra de estado
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
                // Lista de canciones
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length, // Número de canciones
                    itemBuilder: (context, index) {
                      final song = songs[index]; // Accede a la canción actual
                      return Center(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8), // Espacio entre tarjetas
                          color: Colors.grey[900]?.withOpacity(0.8), // Color oscuro translúcido
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85, // Ancho del 85% de la pantalla
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10), // Espacio interno
                              
                              // Imagen de la canción o ícono si no hay
                              leading: song.posterUrl != null && song.posterUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8), // Bordes redondeados para la imagen
                                      child: Image.network(
                                        song.posterUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover, // Recorta la imagen para que encaje bien
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
                                ),
                              ),
                              
                              // Artista y año de la canción
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
