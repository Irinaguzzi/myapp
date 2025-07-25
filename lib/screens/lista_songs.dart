import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/presentation/providers.dart'; // importo el provider de canciones
import 'package:myapp/domain/song_detail_args.dart'; // importo los argumentos para navegar a detail
import 'package:myapp/screens/song_detail.dart'; // importo enum SongDetailMode
import 'package:go_router/go_router.dart';

class ListaSongs extends ConsumerWidget {
  const ListaSongs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsList = ref.watch(songsProvider);

    // divido en dos columnas
    final leftColumn = songsList.sublist(0, (songsList.length / 2).ceil());
    final rightColumn = songsList.sublist((songsList.length / 2).ceil(), songsList.length);
    final pairedSongs = List.generate(leftColumn.length, (index) {
      return [
        leftColumn[index],
        index < rightColumn.length ? rightColumn[index] : null,
      ];
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromARGB(153, 0, 0, 0)),
          ),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'My Playlist:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pairedSongs.length,
                    itemBuilder: (context, index) {
                      final pair = pairedSongs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Row(
                          children: pair.map((song) {
                            if (song == null) {
                              return const Expanded(child: SizedBox());
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  color: Colors.grey[900]?.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: SizedBox(
                                    height: 68,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      onTap: () {
                                        // al tocar la cancion voy a song detail en modo view
                                        GoRouter.of(context).push(
                                          '/song-detail',
                                          extra: SongDetailArgs(song: song, mode: SongDetailMode.view),
                                        );
                                      },
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
                                          : const Icon(Icons.music_note, color: Colors.white, size: 36),
                                      title: Text(
                                        song.title,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      subtitle: Text(
                                        '${song.singer} (${song.year})',
                                        style: const TextStyle(color: Colors.white70, fontSize: 11),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // boton para agregar nueva cancion
          GoRouter.of(context).push(
            '/song-detail',
            extra: SongDetailArgs(mode: SongDetailMode.add),
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
