import 'package:go_router/go_router.dart';
import 'package:myapp/main.dart';         // Login screen
import 'package:myapp/screens/lista_songs.dart';  // Lista de canciones

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
  ],
);
