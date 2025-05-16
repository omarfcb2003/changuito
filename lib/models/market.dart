class Market {
  final String nombre;
  final String cuit;
  final String localidad;
  final String direccion;

  Market({
    required this.nombre,
    required this.cuit,
    required this.localidad,
    required this.direccion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cuit': cuit,
      'localidad': localidad,
      'direccion': direccion,
    };
  }

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      nombre: map['nombre'] ?? '',
      cuit: map['cuit'] ?? '',
      localidad: map['localidad'] ?? '',
      direccion: map['direccion'] ?? '',
    );
  }

  Market copyWith({
    String? nombre,
    String? cuit,
    String? localidad,
    String? direccion,
  }) {
    return Market(
      nombre: nombre ?? this.nombre,
      cuit: cuit ?? this.cuit,
      localidad: localidad ?? this.localidad,
      direccion: direccion ?? this.direccion,
    );
  }

  @override
  String toString() {
    return 'Market(nombre: $nombre, CUIT: $cuit, Localidad: $localidad, Dirección: $direccion)';
  }
}
