import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:myapp/presentation/providers.dart';
import 'package:myapp/domain/song_detail_args.dart';
import 'package:myapp/screens/song_detail.dart';


class ListaSongs extends ConsumerWidget {
  const ListaSongs({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final likes = ref.watch(likesProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/likes'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, i) {
          final song = songs[i];
          final isLiked = likes.contains(song.id);


          return Card(
            color: Colors.grey[900],
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.white),
              title: Text(
                song.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                song.singer,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.purpleAccent,
                ),
                onPressed: () {
                  ref.read(likesProvider.notifier).toggleLike(song.id);
                },
              ),
              onTap: () {
                context.push(
                  '/song-detail',
                  extra: SongDetailArgs(song: song, mode: SongDetailMode.view),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          context.push(
            '/song-detail',
            extra: SongDetailArgs(mode: SongDetailMode.add),
          );
        },
      ),
    );
  }
}
