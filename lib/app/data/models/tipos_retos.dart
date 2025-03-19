class TipoReto {
  int idTipoReto;
  String descripcion;

  TipoReto({
    required this.idTipoReto,
    required this.descripcion,
  });

  factory TipoReto.fromJson(Map<String, dynamic> json) {
    return TipoReto(
      idTipoReto: json['idTipoReto'],
      descripcion: json['descripcion'],
    );
  }
}