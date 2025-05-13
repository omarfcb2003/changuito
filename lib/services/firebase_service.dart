import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

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

        _showSnackbar(context, '✅ Ticket subido y guardado correctamente');
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
