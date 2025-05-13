import 'package:flutter/material.dart';
import 'dart:io';
import '../services/firebase_service.dart';

class ProcessButton extends StatefulWidget {
  final File file;

  const ProcessButton({Key? key, required this.file}) : super(key: key);

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isProcessing = false;
  bool _wasProcessedSuccessfully = false;

  Future<void> _processFile() async {
    if (!widget.file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ El archivo ya no existe')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _wasProcessedSuccessfully = false;
    });

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text('Procesando ticket...')),
          ],
        ),
      ),
    );

    await _firebaseService.uploadTicketFile(widget.file, context);

    if (context.mounted) {
      Navigator.of(context).pop(); // Cerrar loading
      setState(() {
        _isProcessing = false;
        _wasProcessedSuccessfully = true;
      });

      // Ocultar mensaje luego de unos segundos
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _wasProcessedSuccessfully = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isProcessing ? null : _processFile,
          child: const Text('Procesar Ticket'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        if (_wasProcessedSuccessfully) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text(
                '¡Ticket procesado con éxito!',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
