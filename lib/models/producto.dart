class Producto {
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;
  final String codigo;

  Producto({
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
    required this.codigo,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      nombre: map['nombre'] ?? '',
      cantidad: map['cantidad'] ?? 1,
      precioUnitario: (map['precioUnitario'] ?? 0).toDouble(),
      precioTotal: (map['precioTotal'] ?? 0).toDouble(),
      codigo: map['codigo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'precioTotal': precioTotal,
      'codigo': codigo,
    };
  }

  @override
  String toString() {
    return '$nombre x$cantidad @ \$${precioUnitario.toStringAsFixed(2)} = \$${precioTotal.toStringAsFixed(2)}';
  }
}
