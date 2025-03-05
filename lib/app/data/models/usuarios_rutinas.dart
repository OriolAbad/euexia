class UsuariosRutinas {
  int idUsuario;
  int idRutina;
  bool publicada;

  UsuariosRutinas({
    required this.idUsuario,
    required this.idRutina,
    this.publicada = false,
  });

  factory UsuariosRutinas.fromJson(Map<String, dynamic> json) {
    return UsuariosRutinas(
      idUsuario: json['idUsuario'],
      idRutina: json['idRutina'],
      publicada: json['publicada'] ?? false,
    );
  }
}