import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/firebase_service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _firebaseService = FirebaseService();
  File? file;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Changuito')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 80, color: Colors.green),
              SizedBox(height: 24),
              Text(
                'Subí tu ticket de supermercado (PDF)',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Botón para subir el PDF
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      file = File(result.files.single.path!);
                      fileName = result.files.single.name;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ticket cargado: ${fileName!}')),
                    );
                  }
                },
                child: Text('Subir Ticket PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),

              // Mostrar botón de procesamiento solo si hay archivo
              if (file != null) ...[
                SizedBox(height: 24),
                Text('Último archivo cargado:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text(fileName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _firebaseService.uploadTicketFile(file!, context);
                  },
                  child: Text('Procesar Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
