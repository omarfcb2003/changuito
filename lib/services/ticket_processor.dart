import 'dart:io';
import 'package:flutter/material.dart';
import 'firebase_service.dart';
import '../models/market.dart';

class TicketProcessor {
  static Future<void> process(
    BuildContext context,
    File file,
    String extractedText,
    Market market,
  ) async {
    final firebaseService = FirebaseService();

    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ El archivo ya no existe')),
      );
      return;
    }

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
      await firebaseService.uploadTicketFile(
        file,
        extractedText,
        context,
        market: market,
      );
      print('✅ uploadTicketFile terminado');

      if (context.mounted) Navigator.of(context).pop();
      showSuccessBanner(context);
    } catch (e) {
      print('❌ Error en uploadTicketFile: $e');
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  static void showSuccessBanner(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 100,
        left: 24,
        right: 24,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: Colors.green.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '¡Ticket procesado con éxito!',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 4), entry.remove);
  }
}
