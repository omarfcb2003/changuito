import 'package:flutter/material.dart';
import 'dart:io';
import '../services/firebase_service.dart';
import '../models/market.dart';

class ProcessButton extends StatefulWidget {
  final File file;
  final String extractedText;
  final Market market;

  const ProcessButton({
    Key? key,
    required this.file,
    required this.extractedText,
    required this.market,
  }) : super(key: key);

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

    // Mostrar diálogo de carga
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

    try {
      print('⏳ Iniciando uploadTicketFile...');
      await _firebaseService.uploadTicketFile(
        widget.file,
        widget.extractedText,
        context,
        market: widget.market,
      );
      print('✅ uploadTicketFile terminado');
    } catch (e) {
      print('❌ Error en uploadTicketFile: $e');
      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
      setState(() => _isProcessing = false);
      return;
    }

    if (context.mounted) {
      Navigator.of(context).pop(); // Cerrar diálogo

      setState(() {
        _isProcessing = false;
        _wasProcessedSuccessfully = true;
      });

      // Ocultar el mensaje después de 4 segundos
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Procesar Ticket'),
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
