import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  /// Procesa una lista de imágenes y devuelve todo el texto extraído como un solo string
  Future<String> extractTextFromImages(List<File> imageFiles) async {
    String allText = '';

    for (File image in imageFiles) {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      allText += recognizedText.text + '\n\n';
    }

    return allText;
  }

  /// Libera los recursos del OCR (importante si se usa intensivamente)
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}
