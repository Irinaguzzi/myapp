import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/domain/song_detail_args.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/song_detail.dart';

class LikedSongsPage extends ConsumerWidget {
  const LikedSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final likes = ref.watch(likesProvider);

    final likedSongs = songs.where((s) => likes.contains(s.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones liked'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: likedSongs.isEmpty
            ? const Center(child: Text('No tenés canciones liked', style: TextStyle(color: Colors.white70)))
            : ListView.builder(
                itemCount: likedSongs.length,
                itemBuilder: (context, index) {
                  final song = likedSongs[index];
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: song.posterUrl != null && song.posterUrl!.isNotEmpty
                          ? Image.network(song.posterUrl!, width: 44, height: 44, fit: BoxFit.cover)
                          : const Icon(Icons.music_note, color: Colors.white),
                      title: Text(song.title, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${song.singer} (${song.year})', style: const TextStyle(color: Colors.white70)),
                      onTap: () {
                        GoRouter.of(context).push('/song-detail', extra: SongDetailArgs(song: song, mode: SongDetailMode.view));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
