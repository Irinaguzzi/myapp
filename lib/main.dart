import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/router/router.dart'; // lista de usuarios
import 'package:go_router/go_router.dart'; // navegación
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/presentation/providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // inicializo Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase usando las opciones generadas por flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'mi app de canciones',
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaginaDeInicio extends ConsumerStatefulWidget {
  const PaginaDeInicio({super.key});

  @override
  EstadoPaginaDeInicio createState() => EstadoPaginaDeInicio();
}

class EstadoPaginaDeInicio extends ConsumerState<PaginaDeInicio> {
  final controladorUsuario = TextEditingController();
  final controladorContra = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ cuando arranca la app, traigo todos los usuarios de Firebase
    Future.microtask(() {
      ref.read(usersProvider.notifier).getAllUsers();
    });
  }
  void iniciarSesion() {
  final usuario = controladorUsuario.text;
  final contra = controladorContra.text;

  if (usuario.isEmpty || contra.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('por favor, completá el usuario y/o la contraseña')),
    );
    return;
  }

  // ahora lee la lista de usuarios desde Firebase
  final usersList = ref.read(usersProvider);
  bool userExists = usersList.any(
    (u) => u.username == usuario && u.password == contra,
  );

    if (!userExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('usuario o contraseña incorrectos')),
    );
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('inicio de sesión exitoso')),
    );
    GoRouter.of(context).go('/lista');
    } 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          color: Colors.grey[900],
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'iniciar sesión',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: controladorUsuario,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'usuario',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: controladorContra,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'contraseña',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'INGRESAR',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
