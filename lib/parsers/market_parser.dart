// lib/parsers/market_parser.dart
import '../models/market.dart';
import '../utils/text_utils.dart';

Market? parseMarketFromText(String rawText) {
  final text = normalizeText(rawText);

  print('--- TEXTO NORMALIZADO ---');
  print(text);

  final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  if (lines.length < 8) {
    print('⚠️ Texto muy corto. No se puede parsear con formato esperado.');
    return null;
  }

  final nombre = lines[0].split(' ').first;
  final direccion = lines[2];
  final localidad = lines[7];

  final cuitRegExp = RegExp(r'\d{2}-\d{8}-\d');
  final cuitLine = lines[4];
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
