import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:uuid/uuid.dart';

class PdfToImageService {
  /// Descarga un PDF desde una URL y lo guarda como archivo temporal
  Future<File> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/ticket_temp.pdf');

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Convierte cada página del PDF en una imagen PNG y devuelve una lista de archivos
  Future<List<File>> convertPdfToImages(File pdfFile) async {
    final document = await PdfDocument.openFile(pdfFile.path);
    final List<File> imageFiles = [];
    final uuid = Uuid();

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final renderedPage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );

      if (renderedPage != null) {
        final tempDir = await getTemporaryDirectory();
        final imageFile = File('${tempDir.path}/page_${uuid.v4()}.png');
        await imageFile.writeAsBytes(renderedPage.bytes);
        imageFiles.add(imageFile);

        // 🖼️ DEBUG: mostrar ruta de imagen generada
        print('✅ Imagen generada de la página $i: ${imageFile.path}');
      }

      await page.close();
    }

    await document.close();

    // ✅ DEBUG: total de imágenes generadas
    print('📄 Total de páginas convertidas a imagen: ${imageFiles.length}');

    return imageFiles;
  }
}
