class Retos {
  int idReto;
  String titulo;
  String descripcion;
  int puntos;
  int idTipoReto;
  int idDificultad;

  Retos({
    required this.idReto,
    required this.titulo,
    required this.descripcion,
    required this.puntos,
    required this.idTipoReto,
    required this.idDificultad,
  });

  factory Retos.fromJson(Map<String, dynamic> json) {
    return Retos(
      idReto: json['idReto'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntos: json['puntos'],
      idTipoReto: json['idTipoReto'],
      idDificultad: json['idDificultad'],
    );
  }
}