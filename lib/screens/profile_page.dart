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
  final emailController = TextEditingController();
  bool editing = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? '';
  }

Future<void> guardarCambios() async {
  final newEmail = emailController.text.trim();
  final fb_auth.User? user = fb_auth.FirebaseAuth.instance.currentUser;

  if (user == null) return;
  if (newEmail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('El email no puede estar vacío')),
    );
    return;
  }

  setState(() => loading = true);

  try {
    await user.verifyBeforeUpdateEmail(newEmail);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({'email': newEmail}, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email actualizado exitosamente!')),
    );

    setState(() => editing = false);
  } on fb_auth.FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
  } finally {
    setState(() => loading = false);
  }
}

  
  Future<void> cerrarSesion() async {
    await fb_auth.FirebaseAuth.instance.signOut();
    if (mounted) GoRouter.of(context).go('/');
  }

  @override
  Widget build(BuildContext context) {
    final user = fb_auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.grey[900],
                child: ListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: editing
                      ? TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                        )
                      : Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              if (editing)
                ElevatedButton(
                  onPressed: loading ? null : guardarCambios,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar'),
                )
              else
                ElevatedButton(
                  onPressed: () => setState(() => editing = true),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  child: const Text('Editar perfil'),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: cerrarSesion,
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
