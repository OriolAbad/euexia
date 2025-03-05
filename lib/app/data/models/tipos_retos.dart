class TiposRetos {
  int idTipoReto;
  String descripcion;

  TiposRetos({
    required this.idTipoReto,
    required this.descripcion,
  });

  factory TiposRetos.fromJson(Map<String, dynamic> json) {
    return TiposRetos(
      idTipoReto: json['idTipoReto'],
      descripcion: json['descripcion'],
    );
  }
}