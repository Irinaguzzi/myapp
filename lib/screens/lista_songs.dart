import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/domain/song_detail_args.dart';
import 'package:myapp/screens/song_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListaSongs extends ConsumerStatefulWidget {
  const ListaSongs({super.key});

  @override
  ConsumerState<ListaSongs> createState() => _ListaSongsState();
}

class _ListaSongsState extends ConsumerState<ListaSongs> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(songsProvider.notifier).getAllSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songsList = ref.watch(songsProvider);

    final leftColumn = songsList.sublist(0, (songsList.length / 2).ceil());
    final rightColumn =
        songsList.sublist((songsList.length / 2).ceil(), songsList.length);

    final pairedSongs = List.generate(leftColumn.length, (index) {
      return [
        leftColumn[index],
        index < rightColumn.length ? rightColumn[index] : null,
      ];
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                GoRouter.of(context).go('/');
              }
            },
          )
        ],
      ),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: pairedSongs.length,
                    itemBuilder: (context, index) {
                      final pair = pairedSongs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Row(
                          children: pair.map((song) {
                            if (song == null) {
                              return const Expanded(child: SizedBox());
                            }
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  color: Colors.grey[900]?.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: SizedBox(
                                    height: 68,
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8),
                                      onTap: () {
                                        GoRouter.of(context).push(
                                          '/song-detail',
                                          extra: SongDetailArgs(
                                              song: song,
                                              mode: SongDetailMode.view),
                                        );
                                      },
                                      leading: song.posterUrl != null &&
                                              song.posterUrl!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                song.posterUrl!,
                                                width: 44,
                                                height: 44,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(Icons.music_note,
                                              color: Colors.white, size: 36),
                                      title: Text(
                                        song.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      subtitle: Text(
                                        '${song.singer} (${song.year})',
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11),
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
