class TipoReto {
  int? idTipoReto; // Ahora es opcional
  String descripcion;
  int horas;

  TipoReto({
    this.idTipoReto, // No es obligatorio
    required this.descripcion,
    required this.horas,
  });

  factory TipoReto.fromJson(Map<String, dynamic> json) {
    return TipoReto(
      idTipoReto: json['idtiporeto'],
      descripcion: json['descripcion'],
      horas: json['horas'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'descripcion': descripcion,
      'horas': horas,
    };

    if (idTipoReto != null) {
      data['idtiporeto'] = idTipoReto.toString();
    }

    return data;
  }
}
