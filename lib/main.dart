import 'package:flutter/material.dart';
import 'package:myapp/core/router/router.dart';  // Ajusta la ruta si es necesario
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Mi app de canciones',
      debugShowCheckedModeBanner: false,
    );
  }
}

// widget con estado (stateful - se queda) para la página de inicio
class PaginaDeInicio extends StatefulWidget {
  @override
  EstadoPaginaDeInicio createState() => EstadoPaginaDeInicio();
}

class EstadoPaginaDeInicio extends State<PaginaDeInicio> {
  //para leer los valores de los campos de texto
  final controladorUsuario = TextEditingController();
  final controladorContra = TextEditingController();

  // usuario y contracorrectos
  final usuarioCorrecto = 'chichamilanesa';
  final contraCorrecta = '19.11';

  // función que se ejecuta al presionar el botón "Ingresar"
  void iniciarSesion() {
    final usuario =
        controladorUsuario.text; // obtiene el texto del campo de usuario
    final contra =
        controladorContra.text; // obtiene el texto del campo de contraseña

    // verifica si algún campo está vacío
    if (usuario == '' || contra == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completá el usuario y/o la contraseña.'),
        ),
      );
    }
    // verifica si la contra y el usuario son incorrectas
    else if (usuario != usuarioCorrecto || contra != contraCorrecta) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario o contraseña incorrectos.')),
      );
    }
    // si todo es correcto muestra el mensaje
    else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Inicio de sesión exitoso.')),
  );
  GoRouter.of(context).go('/lista_songs');

}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')), // barra superior con título
      body: Padding(
        padding: const EdgeInsets.all(20.0), // espacio interno
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // centra los widgets verticalmente
          children: [
            TextField(
              controller:
                  controladorUsuario, // conecta el controlador del usuario
              decoration: InputDecoration(
                labelText: 'Usuario',
              ), // nombre del campo
            ),
            TextField(
              controller:
                  controladorContra, //conecta el controlador de la contraseña
              obscureText: true, // Oculta la contra
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ), // nombre del campo
            ),
            SizedBox(height: 20), // espacio entre los campos y el botón
            ElevatedButton(
              onPressed: iniciarSesion, // accion al presionar el botón
              child: Text('Ingresar'), // texto del botón
            ),
          ],
        ),
      ),
    );
  }
}
