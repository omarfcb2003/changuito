import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveTicket({
    required String userName,
    required String fileName,
    required String downloadUrl,
    required DateTime date,
  }) async {
    try {
      await _db.collection('tickets').add({
        'user': userName,
        'file_name': fileName,
        'url': downloadUrl,
        'date': date.toIso8601String(),
      });

      print('✅ Ticket guardado en Firestore');
    } catch (e) {
      print('❌ Error al guardar en Firestore: $e');
    }
  }
}
