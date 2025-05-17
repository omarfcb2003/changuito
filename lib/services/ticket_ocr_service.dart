import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class TicketOcrService {
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final lines = <TextLine>[];
    for (final block in recognizedText.blocks) {
      lines.addAll(block.lines);
    }

    lines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    final List<List<TextLine>> groupedLines = [];
    const double lineGroupingThreshold = 10.0;

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

    final textLines = <String>[];

    for (final group in groupedLines) {
      final elements = group.expand((line) => line.elements).toList()
        ..sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

      String mergedLine = elements.map((e) => e.text).join(' ');

      // 🔧 Corregir el símbolo de porcentaje mal leído
      mergedLine = mergedLine.replaceAllMapped(
        RegExp(r'\(21\.00[869]\)'),
        (match) => '(21.00%)',
      );

      // 🧹 Eliminar el IVA
      mergedLine = mergedLine.replaceAll(RegExp(r'\(.*?%\)'), '').trim();

      // ⚠️ Cortar la lectura si se detecta el delimitador
      if (mergedLine.contains('==============================')) {
        break;
      }

      // 🔢 Eliminar espacios internos en números largos (códigos de barra)
      mergedLine = mergedLine.replaceAllMapped(
        RegExp(r'\b(\d{6,})\s+(\d{5,})\b'),
        (match) => '${match[1]}${match[2]}',
      );

      textLines.add(mergedLine);
    }

    final finalText = textLines.join('\n');

    final cacheDir = await getTemporaryDirectory();
    final txtFile = File('${cacheDir.path}/ticket_text.txt');
    await txtFile.writeAsString(finalText);

    return finalText;
  }
}
