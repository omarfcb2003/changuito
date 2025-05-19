// lib/utils/text_utils.dart
String normalizeText(String input) {
  return input
      .replaceAll(RegExp(r'\u00a0'), ' ')
      .replaceAll(RegExp(r'[\u2010-\u2015\u2212\u00ad‐‑‒–—−]'), '-')
      .replaceAllMapped(RegExp(r'\b(CABA|FECHA|FACTURA|HORA|TOTAL|CAJERO|P\.V\.)\b', caseSensitive: false), (match) => '\n${match.group(0)}')
      .replaceAll(RegExp(r'(?<=\d)\s{2,}(?=\d)'), '\n')
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .trim()
      .toUpperCase();
}
