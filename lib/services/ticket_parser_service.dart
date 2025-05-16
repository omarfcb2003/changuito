import '../models/market.dart';

class TicketParserService {
  String _normalize(String input) {
    return input
        .replaceAll(RegExp(r'\u00a0'), ' ') // espacio no separable
        .replaceAll(
          RegExp(r'[\u2010\u2011\u2012\u2013\u2014\u2015\u2212\u00ad‐‑‒–—−]'),
          '-', // guiones raros
        )
        // Insertar saltos de línea antes de palabras clave (opcional)
        .replaceAllMapped(
          RegExp(r'\b(CABA|FECHA|FACTURA|HORA|TOTAL|CAJERO|P\.V\.)\b', caseSensitive: false),
          (match) => '\n${match.group(0)}',
        )
        // Insertar salto donde haya dos espacios entre números (opcional)
        .replaceAll(RegExp(r'(?<=\d)\s{2,}(?=\d)'), '\n')
        // 🔧 Esta es la línea corregida que preserva los \n
        .replaceAll(RegExp(r'[ \t]+'), ' ') // solo colapsa espacios y tabs, NO saltos de línea
        .trim()
        .toUpperCase();
  }

  Market? parseMarket(String rawText) {
    final text = _normalize(rawText);

    print('--- TEXTO NORMALIZADO ---');
    print(text);

    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    if (lines.length < 8) {
      print('⚠️ Texto muy corto. No se puede parsear con formato esperado.');
      return null;
    }

    final nombre = lines[0].split(' ').first;
    final direccion = lines[2]; // línea 3
    final localidad = lines[7]; // línea 8

    final cuitRegExp = RegExp(r'\d{2}-\d{8}-\d');
    final cuitLine = lines[4]; // línea 5
    final cuitMatch = cuitRegExp.firstMatch(cuitLine);
    final cuit = cuitMatch?.group(0) ?? 'CUIT no encontrado';

    print('📌 Nombre: $nombre');
    print('📌 Dirección: $direccion');
    print('📌 CUIT: $cuit');
    print('📌 Localidad: $localidad');

    if (cuit == 'CUIT no encontrado') return null;

    return Market(
      nombre: nombre,
      direccion: direccion,
      cuit: cuit,
      localidad: localidad,
    );
  }
}
