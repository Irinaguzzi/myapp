import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/screens/login_page.dart';
import 'package:myapp/screens/register_page.dart';
import 'package:myapp/screens/profile_page.dart';
import 'package:myapp/screens/liked_songs.dart';
import 'package:myapp/screens/lista_songs.dart';
import 'package:myapp/screens/song_detail.dart';       
import 'package:myapp/domain/song_detail_args.dart';     

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // LOGIN
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),

    // REGISTER
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),

    // LISTA DE CANCIONES
    GoRoute(
      path: '/lista',
      builder: (BuildContext context, GoRouterState state) {
        return const ListaSongs();
      },
    ),

    // PROFILE
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),

    // LIKES
    GoRoute(
      path: '/likes',
      builder: (BuildContext context, GoRouterState state) {
        return const LikedSongsPage();
      },
    ),

    // SONG DETAIL 👇 (mismo formato, solo que usa los args)
    GoRoute(
      path: '/song-detail',
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as SongDetailArgs;
        return SongDetailScreen(
          song: args.song,
          mode: args.mode,
        );
      },
    ),
  ],
);
