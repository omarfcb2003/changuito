import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login_screen.dart'; // 👈 importás la nueva pantalla de login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('🔥 Firebase inicializado correctamente');
  } catch (e) {
    print('❌ Firebase error: $e');
  }

  runApp(ChanguitoApp());
}

class ChanguitoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Changuito',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // 👈 redirecciona desde LoginScreen
    );
  }
}
