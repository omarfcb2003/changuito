import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadButton extends StatelessWidget {
  final Function(File, String) onFileSelected;

  const UploadButton({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        );

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          final fileName = result.files.single.name;
          final extension = fileName.split('.').last.toLowerCase();

          onFileSelected(file, extension);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('📁 Ticket seleccionado: $fileName')),
          );
        }
      },
      child: const Text('Subir Ticket (PDF o Imagen)'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
