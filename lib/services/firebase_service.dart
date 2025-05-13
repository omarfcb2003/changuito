import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'firestore_service.dart';
import 'pdf_to_image_service.dart';
import 'ocr_service.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  final PdfToImageService _pdfService = PdfToImageService();
  final OCRService _ocrService = OCRService();

  Future<void> uploadTicketFile(File file, BuildContext context) async {
    try {
      // 1. Subir archivo a Firebase Storage
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('tickets/ticket_$timestamp.pdf');

      if (!file.existsSync()) {
        print('❌ El archivo no existe: ${file.path}');
        _showSnackbar(context, '❌ El archivo no se encuentra');
        return;
      }

      final uploadTask = ref.putFile(file);
      final snapshot =
          await uploadTask.whenComplete(() => print('📤 Subida completada'));

      if (snapshot.state != TaskState.success) {
        throw Exception('❌ La subida falló en Firebase Storage.');
      }

      final downloadUrl = await ref.getDownloadURL();
      print('✅ Archivo subido: $downloadUrl');

      // 2. Guardar metadata en Firestore
      final userEmail = _auth.currentUser?.email ?? 'desconocido';
      await _firestore.saveTicket(
        userName: userEmail,
        fileName: file.path.split('/').last,
        downloadUrl: downloadUrl,
        date: DateTime.now(),
      );

      // 3. Descargar y convertir PDF en imágenes
      final localPdf = await _pdfService.downloadPdf(downloadUrl);
      final imageFiles = await _pdfService.convertPdfToImages(localPdf);

      // 4. Ejecutar OCR sobre las imágenes
      final extractedText = await _ocrService.extractTextFromImages(imageFiles);
      await _ocrService.dispose();

      // 5. Guardar texto en archivo temporal para depuración
      final tempDir = await getTemporaryDirectory();
      final debugFile = File('${tempDir.path}/ticket_debug.txt');
      await debugFile.writeAsString(extractedText);

      print('🖨️ Texto extraído (preview):\n'
          '${extractedText.substring(0, extractedText.length.clamp(0, 500))}');
      print('🗂️ Texto completo guardado en: ${debugFile.path}');

      _showSnackbar(context, '✅ Ticket subido y procesado correctamente');
    } catch (e) {
      print('❌ Error en uploadTicketFile: $e');
      _showSnackbar(context, '❌ Error al subir o procesar el ticket');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
