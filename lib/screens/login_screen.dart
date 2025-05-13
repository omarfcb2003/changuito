import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../widgets/google_signin_button.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    if (user != null) {
      _redirectToMain();
    }
  }

  void _redirectToMain() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  Future<void> _signIn() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      _redirectToMain();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Falló el inicio de sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GoogleSignInButton(
            onPressed: _signIn,
          ),
        ),
      ),
    );
  }
}
