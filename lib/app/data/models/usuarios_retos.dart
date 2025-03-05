class UsuariosRetos {
  int idReto;
  int idUsuario;
  DateTime fechaInicio;
  DateTime? fechaFin;
  bool completado;

  UsuariosRetos({
    required this.idReto,
    required this.idUsuario,
    required this.fechaInicio,
    this.fechaFin,
    this.completado = false,
  });

  factory UsuariosRetos.fromJson(Map<String, dynamic> json) {
    return UsuariosRetos(
      idReto: json['idReto'],
      idUsuario: json['idUsuario'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
      completado: json['completado'] ?? false,
    );
  }
}