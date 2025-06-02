import 'package:flutter/material.dart';
import 'package:myapp/core/router/router.dart'; // Importa configuración de rutas
import 'package:go_router/go_router.dart'; // Librería para navegación

void main() {
  runApp(const MyApp()); // Ejecuta la aplicación
}

// Widget principal sin estado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // Usa la configuración de rutas definida
      title: 'Mi app de canciones',
      debugShowCheckedModeBanner: false, // Quita la etiqueta de "debug"
    );
  }
}

// Página de inicio con estado
class PaginaDeInicio extends StatefulWidget {
  @override
  EstadoPaginaDeInicio createState() => EstadoPaginaDeInicio();
}

class EstadoPaginaDeInicio extends State<PaginaDeInicio> {
  // Controladores para leer el texto ingresado en los campos
  final controladorUsuario = TextEditingController();
  final controladorContra = TextEditingController();

  // Usuario y contraseña correctos
  final usuarioCorrecto = 'chichamilanesa';
  final contraCorrecta = '19.11';

  // Función que se llama al presionar el botón "Ingresar"
  void iniciarSesion() {
    final usuario = controladorUsuario.text;
    final contra = controladorContra.text;

    // Si algún campo está vacío, muestra mensaje de error
    if (usuario == '' || contra == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completá el usuario y/o la contraseña.')),
      );
    }
    // Si usuario o contraseña no coinciden, muestra mensaje de error
    else if (usuario != usuarioCorrecto || contra != contraCorrecta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos.')),
      );
    }
    // Si todo está bien, muestra mensaje de éxito y navega a la pantalla de lista
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso.')),
      );
      GoRouter.of(context).go('/lista');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro para toda la pantalla
      body: Center(
        child: Card(
          // Card principal que contiene todo el formulario
          color: Colors.grey[900], // Color gris oscuro
          elevation: 10, // Sombra para resaltar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Espacio interno del card
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320), // Máximo ancho
              child: Column(
                mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                children: [
                  // Título
                  const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio debajo del título

                  // Card para el campo de usuario
                  Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: controladorUsuario,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none, // Sin borde visible
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // Espacio entre campos

                  // Card para el campo de contraseña
                  Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: controladorContra,
                        obscureText: true, // Oculta el texto para la contraseña
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio antes del botón

                  // Botón "Ingresar" más visible
                  ElevatedButton(
                    onPressed: iniciarSesion, // Llama a la función al presionar
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent, // Color llamativo
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'INGRESAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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
