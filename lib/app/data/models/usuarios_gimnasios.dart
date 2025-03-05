class UsuariosGimnasios {
  int idUsuario;
  int idGimnasio;
  bool favorito;

  UsuariosGimnasios({
    required this.idUsuario,
    required this.idGimnasio,
    this.favorito = false,
  });

  factory UsuariosGimnasios.fromJson(Map<String, dynamic> json) {
    return UsuariosGimnasios(
      idUsuario: json['idUsuario'],
      idGimnasio: json['idGimnasio'],
      favorito: json['favorito'] ?? false,
    );
  }
}