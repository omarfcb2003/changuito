import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

import '../models/market.dart';

class FirebaseService {
  Future<void> uploadTicketFile(
    File file,
    String extractedText,
    BuildContext context, {
    required Market market,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Obtener la extensión real del archivo
      final extension = path.extension(file.path).replaceFirst('.', '');
      final fileName = 'ticket_$timestamp.$extension';

      final ref = FirebaseStorage.instance.ref().child('tickets/$fileName');

      if (!file.existsSync()) {
        throw Exception('El archivo no existe');
      }

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'desconocido';

      final dataToSave = {
        'market': market.toMap(),
        'date': DateTime.now().toUtc().toIso8601String(),
        'filename': fileName,
        'url': downloadUrl,
        'user': userEmail,
        'raw_text': extractedText, // Opcional para trazabilidad o debug
      };

      await FirebaseFirestore.instance.collection('tickets').add(dataToSave);

      debugPrint('✅ Datos guardados en Firestore: $dataToSave');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket procesado y guardado con éxito')),
      );
    } catch (e) {
      debugPrint('❌ Error al procesar el ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir o procesar el ticket.')),
      );
    }
  }
}
