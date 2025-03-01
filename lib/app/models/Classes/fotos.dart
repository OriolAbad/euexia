class Fotos {
  int idFoto;
  String urlFoto;
  int idUsuario;

  Fotos({
    required this.idFoto,
    required this.urlFoto,
    required this.idUsuario,
  });

  factory Fotos.fromJson(Map<String, dynamic> json) {
    return Fotos(
      idFoto: json['idFoto'],
      urlFoto: json['urlFoto'],
      idUsuario: json['idUsuario'],
    );
  }
}