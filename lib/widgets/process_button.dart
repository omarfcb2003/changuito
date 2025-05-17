import 'package:flutter/material.dart';
import 'dart:io';
import '../services/ticket_processor.dart';
import '../models/market.dart';

class ProcessButton extends StatelessWidget {
  final File file;
  final String extractedText;
  final Market market;

  const ProcessButton({
    super.key,
    required this.file,
    required this.extractedText,
    required this.market,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        TicketProcessor.process(context, file, extractedText, market);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Procesar Ticket'),
    );
  }
}
