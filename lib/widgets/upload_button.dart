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
          allowedExtensions: ['pdf'],
        );
        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          final fileName = result.files.single.name;
          onFileSelected(file, fileName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ticket cargado: $fileName')),
          );
        }
      },
      child: Text('Subir Ticket PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}
