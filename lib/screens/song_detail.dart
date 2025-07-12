import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/domain/class.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/domain/song_detail_args.dart';
enum SongDetailMode { view, add, edit }

class SongDetailScreen extends ConsumerStatefulWidget {
  final Song? song;
  final SongDetailMode mode;

  const SongDetailScreen({super.key, this.song, required this.mode});

  @override
  ConsumerState<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController singerController;
  late TextEditingController yearController;
  late TextEditingController posterUrlController;
  late TextEditingController lyricsController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.song?.title ?? '');
    singerController = TextEditingController(text: widget.song?.singer ?? '');
    yearController = TextEditingController(text: widget.song?.year.toString() ?? '');
    posterUrlController = TextEditingController(text: widget.song?.posterUrl ?? '');
    lyricsController = TextEditingController(text: widget.song?.lyric ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isView = widget.mode == SongDetailMode.view;
    final isEdit = widget.mode == SongDetailMode.edit;
    final isAdd = widget.mode == SongDetailMode.add;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          isAdd
              ? 'Agregar canción'
              : isEdit
                  ? 'Editar canción'
                  : 'Detalles de la canción',
        ),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.deepPurpleAccent), // iconos violetas
        actions: [
          if (isView)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                GoRouter.of(context).pushReplacement(
                  '/song-detail',
                  extra: SongDetailArgs(song: widget.song, mode: SongDetailMode.edit),
                );
              },
            ),
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(songsProvider.notifier).update((state) {
                  return state.where((s) => s.id != widget.song!.id).toList();
                });
                GoRouter.of(context).pop();
              },
            ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                cardCampo(titleController, 'Título', enabled: !isView),
                const SizedBox(height: 12),
                cardCampo(singerController, 'Artista', enabled: !isView),
                const SizedBox(height: 12),
                cardCampo(yearController, 'Año', enabled: !isView, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                cardCampo(posterUrlController, 'URL del poster', enabled: !isView),
                const SizedBox(height: 12),
                cardCampo(lyricsController, 'Letra (Lyrics)', enabled: !isView, keyboardType: TextInputType.multiline),
                const SizedBox(height: 24),
                if (!isView)
                  ElevatedButton(
                    onPressed: () {
                      final newSong = Song(
                        id: isEdit ? widget.song!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        singer: singerController.text,
                        year: int.tryParse(yearController.text) ?? 0,
                        posterUrl: posterUrlController.text,
                        lyric: lyricsController.text.isNotEmpty ? lyricsController.text : null,
                      );

                      if (isAdd) {
                        ref.read(songsProvider.notifier).update((state) => [...state, newSong]);
                      } else if (isEdit) {
                        ref.read(songsProvider.notifier).update((state) {
                          return state.map((s) => s.id == newSong.id ? newSong : s).toList();
                        });
                      }

                      GoRouter.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(isAdd ? 'Agregar' : 'Guardar', style: const TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardCampo(
    TextEditingController controller,
    String label, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
