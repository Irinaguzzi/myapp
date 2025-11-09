import 'package:cloud_firestore/cloud_firestore.dart';


class LocalUser {
  final String id;
  final String username;
  final String password;


  LocalUser({required this.id, required this.username, required this.password});


  factory LocalUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return LocalUser(
      id: doc.id,
      username: data['username'] ?? '',
      password: data['password'] ?? '',
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'password': password,
    };
  }
}


