import 'dart:async';
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
      final fileExtension = path.extension(file.path).replaceFirst('.', '');
      final fileName = 'ticket_$timestamp.$fileExtension';

      final storage = FirebaseStorage.instanceFor(
        bucket: 'changuito-d2608.firebasestorage.app',
      );
      final ref = storage.ref().child('tickets/$fileName');

      if (!file.existsSync()) {
        throw Exception('El archivo no existe');
      }

      final fileSize = await file.length();
      print('📏 Tamaño del archivo: $fileSize bytes');

      // 🧠 Detectar contentType automáticamente
      String contentType = 'application/octet-stream';
      if (fileExtension == 'pdf') contentType = 'application/pdf';
      else if (fileExtension == 'jpg' || fileExtension == 'jpeg') contentType = 'image/jpeg';
      else if (fileExtension == 'png') contentType = 'image/png';

      final metadata = SettableMetadata(contentType: contentType);

      print('📤 Subiendo archivo a Firebase Storage...');
      await ref.putFile(file, metadata).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('⏱️ Timeout al subir el archivo a Firebase Storage');
        },
      );

      print('🔗 Obteniendo URL de descarga...');
      final downloadUrl = await ref.getDownloadURL();

      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'desconocido';

      final dataToSave = {
        'market': market.toMap(),
        'date': DateTime.now().toUtc().toIso8601String(),
        'filename': fileName,
        'url': downloadUrl,
        'user': userEmail,
        'raw_text': extractedText,
      };

      print('📝 Guardando en Firestore...');
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
      rethrow;
    }
  }
}
