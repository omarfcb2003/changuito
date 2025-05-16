import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class TicketOcrService {
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    // ✅ Extraer líneas reales
    final lines = <String>[];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        lines.add(line.text);
      }
    }

    final finalText = lines.join('\n');

    final cacheDir = await getTemporaryDirectory();
    final txtFile = File('${cacheDir.path}/ticket_text.txt');
    await txtFile.writeAsString(finalText);

    return finalText;
  }
}
