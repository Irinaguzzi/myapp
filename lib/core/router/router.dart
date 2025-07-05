import 'package:go_router/go_router.dart';
import 'package:myapp/main.dart';
import 'package:myapp/screens/lista_songs.dart';
import 'package:myapp/screens/song_detail.dart' ;
import 'package:myapp/domain/song_detail_args.dart';


// configuro las rutas principales. extra con un objeto con song + modo
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => PaginaDeInicio(),
    ),
    GoRoute(
      path: '/lista',
      builder: (context, state) => ListaSongs(),
    ),
    GoRoute(
      path: '/song-detail',
      builder: (context, state) {
        final args = state.extra as SongDetailArgs; 
        return SongDetailScreen(song: args.song, mode: args.mode);
      },
    ),
  ],
);
