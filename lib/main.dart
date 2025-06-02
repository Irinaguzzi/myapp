import 'package:flutter/material.dart';
import 'package:myapp/core/router/router.dart'; // Importa las rutas definidas en tu app
import 'package:go_router/go_router.dart'; // Para navegación entre pantallas

void main() {
  runApp(const MyApp()); // Punto de entrada de la app
}

// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // Usa el sistema de rutas personalizado
      title: 'Mi app de canciones',
      debugShowCheckedModeBanner: false, // Oculta el cartel de debug
    );
  }
}

// Widget con estado para manejar campos de entrada y lógica de login
class PaginaDeInicio extends StatefulWidget {
  @override
  EstadoPaginaDeInicio createState() => EstadoPaginaDeInicio();
}

class EstadoPaginaDeInicio extends State<PaginaDeInicio> {
  // Controladores para leer el texto de los campos
  final controladorUsuario = TextEditingController();
  final controladorContra = TextEditingController();

  // Usuario y contraseña válidos (predefinidos)
  final usuarioCorrecto = 'chichamilanesa';
  final contraCorrecta = '19.11';

  // Función que se ejecuta al presionar "Ingresar"
  void iniciarSesion() {
    final usuario = controladorUsuario.text;
    final contra = controladorContra.text;

    // Valida si algún campo está vacío
    if (usuario == '' || contra == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completá el usuario y/o la contraseña.')),
      );
    } 
    // Verifica si los datos no coinciden con los correctos
    else if (usuario != usuarioCorrecto || contra != contraCorrecta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos.')),
      );
    } 
    // Si todo está bien, muestra mensaje y navega a la lista de canciones
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso.')),
      );
      GoRouter.of(context).go('/lista'); // Va a la pantalla de canciones
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro para toda la pantalla
      body: Center(
        child: Card( // Card principal que contiene todo el formulario
          color: Colors.grey[900], // Fondo gris oscuro
          elevation: 10, // Sombra para levantar visualmente la tarjeta
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Espacio interno de la card
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ocupa sólo el espacio necesario
              children: [
                const Text(
                  'Iniciar sesión', // Título de la card
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre título y campos

                // Card del campo de usuario
                Card(
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: controladorUsuario, // Controlador del usuario
                      style: const TextStyle(color: Colors.white), // Texto blanco
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        labelStyle: TextStyle(color: Colors.white70), // Texto gris
                        border: InputBorder.none, // Sin borde estándar
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12), // Espacio entre los campos

                // Card del campo de contraseña
                Card(
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: controladorContra, // Controlador de contraseña
                      obscureText: true, // Oculta el texto para seguridad
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

                // Botón de ingreso
                ElevatedButton(
                  onPressed: iniciarSesion, // Llama a la función de login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent, // Color violeta
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Ingresar'), // Texto del botón
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
