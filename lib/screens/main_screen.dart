import 'package:flutter/material.dart';
import 'dart:io';

import '../services/firebase_service.dart';
import '../services/ticket_parser_service.dart';
import '../services/ticket_ocr_service.dart';

import '../widgets/upload_button.dart';
import '../widgets/process_button.dart';

import '../models/market.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TicketOcrService _ocrService = TicketOcrService();
  final TicketParserService _parser = TicketParserService();

  File? _selectedFile;
  String? _fileName;
  String? _extractedText;
  Market? _parsedMarket;
  bool _isLoading = false;

  Future<void> _handleFileSelected(File file, String extension) async {
    setState(() {
      _isLoading = true;
      _selectedFile = file;
      _fileName = file.path.split('/').last;
      _extractedText = null;
      _parsedMarket = null;
    });

    try {
      final text = await _ocrService.extractTextFromImage(file);
      final market = _parser.parseMarket(text);

      setState(() {
        _extractedText = text;
        _parsedMarket = market;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al extraer texto del ticket: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                'Subí tu ticket de supermercado (imagen)',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              UploadButton(
                onFileSelected: _handleFileSelected,
              ),
              if (_isLoading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                const Text('Extrayendo texto...'),
              ],
              if (_selectedFile != null &&
                  _extractedText != null &&
                  _parsedMarket != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Último archivo cargado:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _fileName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ProcessButton(
                  file: _selectedFile!,
                  extractedText: _extractedText!,
                  market: _parsedMarket!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
