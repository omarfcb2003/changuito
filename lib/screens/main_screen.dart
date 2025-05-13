import 'package:flutter/material.dart';
import 'dart:io';
import '../services/firebase_service.dart';
import '../widgets/upload_button.dart';
import '../widgets/process_button.dart'; // asegúrate de tener este archivo

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  File? _selectedFile;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changuito')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.receipt_long, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Subí tu ticket de supermercado (PDF o Imagen)',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              UploadButton(
                onFileSelected: (File file, String extension) {
                  setState(() {
                    _selectedFile = file;
                    _fileName = file.path.split('/').last;
                  });
                },
              ),

              if (_selectedFile != null) ...[
                const SizedBox(height: 24),
                const Text('Último archivo cargado:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text(_fileName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ProcessButton(file: _selectedFile!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
