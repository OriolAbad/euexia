class Amigos {
  int idUsuario1;
  int idUsuario2;

  Amigos({
    required this.idUsuario1,
    required this.idUsuario2,
  });

  factory Amigos.fromJson(Map<String, dynamic> json) {
    return Amigos(
      idUsuario1: json['idUsuario1'],
      idUsuario2: json['idUsuario2'],
    );
  }
}