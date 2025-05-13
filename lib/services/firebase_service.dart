import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'firestore_service.dart';
import 'pdf_service.dart';

class FirebaseService {
  Future<void> uploadTicketFile(File file, BuildContext context) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = FirebaseStorage.instance
          .ref()
          .child('tickets/ticket_$timestamp.pdf');

      if (!file.existsSync()) {
        print('❌ El archivo no existe en el path: ${file.path}');
        _showSnackbar(context, '❌ El archivo no se encuentra en el sistema');
        return;
      }

      final uploadTask = ref.putFile(file);
      final snapshot =
          await uploadTask.whenComplete(() => print('📤 Subida completada'));

      if (snapshot.state == TaskState.success) {
        final url = await ref.getDownloadURL();
        print('✅ Archivo subido a Firebase: $url');

        final firestore = FirestoreService();
        final currentUser = FirebaseAuth.instance.currentUser;
        final userEmail = currentUser?.email ?? 'desconocido';

        await firestore.saveTicket(
          userName: userEmail,
          fileName: file.path.split('/').last,
          downloadUrl: url,
          date: DateTime.now(),
        );

        // 🧠 Procesamiento del PDF
        final pdfService = PdfService();
        final localFile = await pdfService.downloadPdf(url);
        final extractedText = await pdfService.extractTextFromFile(localFile);

        // 🖨️ Mostrar solo primeros caracteres
        final preview = extractedText.length > 500
            ? extractedText.substring(0, 500)
            : extractedText;
        print('📄 Texto extraído (preview):\n$preview');
        print('📏 Longitud total del texto: ${extractedText.length}');

        // 📝 Guardar texto en archivo
        final tempDir = await getTemporaryDirectory();
        final debugFile = File('${tempDir.path}/ticket_debug.txt');
        await debugFile.writeAsString(extractedText);
        print('🗂️ Texto completo guardado en: ${debugFile.path}');

        _showSnackbar(context, '✅ Ticket subido, guardado y procesado');
      } else {
        throw Exception('❌ La subida falló en Firebase Storage.');
      }
    } catch (e) {
      print('❌ Error al subir archivo: $e');
      _showSnackbar(context, '❌ Error al subir el ticket');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
