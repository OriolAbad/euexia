class TipoReto {
  int idTipoReto;
  String descripcion;
  int horas;

  TipoReto({
    required this.idTipoReto,
    required this.descripcion,
    required this.horas
  });

  factory TipoReto.fromJson(Map<String, dynamic> json) {
    return TipoReto(
      idTipoReto: json['idtiporeto'],
      descripcion: json['descripcion'],
      horas: json['horas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtiporeto': idTipoReto,
      'descripcion': descripcion,
      'horas': horas,
    };
  }
}