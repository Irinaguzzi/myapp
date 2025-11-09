import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  String email = "";
  bool loading = false;


  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }


  Future<void> _cargarDatos() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return;


    // email viene del Auth
    email = user.email ?? '';


    // username viene de Firestore
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await ref.get();


    if (doc.exists) {
      usernameController.text = doc.data()?['username'] ?? '';
    }


    setState(() {});
  }


  Future<void> _guardarUsername() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return;


    final nuevoUsername = usernameController.text.trim();


    if (nuevoUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El nombre de usuario no puede estar vacío")),
      );
      return;
    }


    setState(() => loading = true);


    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'username': nuevoUsername
      }, SetOptions(merge: true));


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username actualizado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }


  Future<void> _cerrarSesion() async {
    await fb_auth.FirebaseAuth.instance.signOut();
    if (mounted) GoRouter.of(context).go('/');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // EMAIL solo lectura
            Card(
              color: Colors.grey[900],
              child: ListTile(
                title: const Text(
                  "Email",
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),


            const SizedBox(height: 20),


            // USERNAME editable
            Card(
              color: Colors.grey[900],
              child: ListTile(
                title: const Text(
                  "Nombre de usuario",
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Escriba su nombre",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),


            // BOTON GUARDAR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: loading ? null : _guardarUsername,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar"),
            ),


            const SizedBox(height: 20),


            // CERRAR SESIÓN
            OutlinedButton(
              onPressed: _cerrarSesion,
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
