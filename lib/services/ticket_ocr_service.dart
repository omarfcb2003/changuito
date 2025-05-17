import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class TicketOcrService {
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    // Recolectar todas las líneas de texto
    final lines = <TextLine>[];
    for (final block in recognizedText.blocks) {
      lines.addAll(block.lines);
    }

    // Ordenar las líneas por posición vertical (top)
    lines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    final List<List<TextLine>> groupedLines = [];
    const double lineGroupingThreshold = 10.0; // px

    // Agrupar líneas cercanas verticalmente
    for (final line in lines) {
      final double lineTop = line.boundingBox.top.toDouble();
      bool added = false;

      for (final group in groupedLines) {
        final double groupTop = group.first.boundingBox.top.toDouble();
        if ((lineTop - groupTop).abs() <= lineGroupingThreshold) {
          group.add(line);
          added = true;
          break;
        }
      }

      if (!added) {
        groupedLines.add([line]);
      }
    }

    final textLines = groupedLines.map((group) {
      // 🔤 Recolectar todos los elementos de texto de las líneas agrupadas
      final elements = group.expand((line) => line.elements).toList();

      // ↔️ Ordenar los elementos horizontalmente (de izquierda a derecha)
      elements.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

      // 🧱 Reconstruir la línea unida
      String mergedLine = elements.map((e) => e.text).join(' ');

      // 🧠 CORRECCIÓN de errores de OCR donde % es mal leído como 8, 6, 9, etc.
      mergedLine = mergedLine.replaceAllMapped(
        RegExp(r'\(21\.00[869]\)'),
        (match) => '(21.00%)',
      );

      // 🧹 Eliminar valor de IVA (21.00%) si existe
      final cleaned = mergedLine.replaceAll(RegExp(r'\(.*?%\)'), '').trim();

      return cleaned;
    }).toList();

    final finalText = textLines.join('\n');

    // 💾 Guardar el resultado como archivo de texto temporal
    final cacheDir = await getTemporaryDirectory();
    final txtFile = File('${cacheDir.path}/ticket_text.txt');
    await txtFile.writeAsString(finalText);

    return finalText;
  }
}
