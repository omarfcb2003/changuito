import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 generado por flutterfire

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase inicializado con firebase_options.dart');
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
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
