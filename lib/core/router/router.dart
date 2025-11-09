import 'package:go_router/go_router.dart';
import 'package:myapp/screens/lista_songs.dart';
import 'package:myapp/screens/login_page.dart';
import 'package:myapp/screens/song_detail.dart';
import 'package:myapp/domain/song_detail_args.dart';

GoRouter router(bool loggedIn) {
  return GoRouter(
    initialLocation: loggedIn ? '/lista' : '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/lista',
        builder: (context, state) => const ListaSongs(),
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
}
