import 'package:go_router/go_router.dart';

import 'package:myapp/screens/login_page.dart';
import 'package:myapp/screens/register_page.dart';
import 'package:myapp/screens/profile_page.dart';
import 'package:myapp/screens/liked_songs.dart';
import 'package:myapp/screens/lista_songs.dart';
final router = GoRouter(
  initialLocation: '/',
  routes: [
    // LOGIN
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),

    // REGISTER
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // HOME / LISTA DE CANCIONES
    GoRoute(
      path: '/lista',
      builder: (context, state) => const ListaSongs(),
    ),

    // PROFILE
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),

    // LIKES
    GoRoute(
      path: '/likes',
      builder: (context, state) => const LikedSongsPage(), // si aún no la tenés, comentala
    ),
  ],
);
