import 'package:flutter/material.dart';
import 'dart:io';
import '../services/firebase_service.dart';

class ProcessButton extends StatelessWidget {
  final File file;

  const ProcessButton({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firebaseService = FirebaseService();

    return ElevatedButton(
      onPressed: () {
        _firebaseService.uploadTicketFile(file, context);
      },
      child: Text('Procesar Ticket'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}
