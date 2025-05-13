import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  /// Descarga un PDF desde Firebase Storage y lo guarda localmente
  Future<File> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/ticket_temp.pdf');

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Extrae todo el texto de un PDF local
  Future<String> extractTextFromFile(File file) async {
    final bytes = await file.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }
}
