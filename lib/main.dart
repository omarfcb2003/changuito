import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generado por FlutterFire

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase inicializado correctamente');
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      print('⚠️ Firebase ya estaba inicializado (duplicate-app), continuando...');
    } else {
      print('❌ Error inesperado al inicializar Firebase: $e');
      rethrow;
    }
  }

  runApp(const ChanguitoApp());
}

class ChanguitoApp extends StatelessWidget {
  const ChanguitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Changuito',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
