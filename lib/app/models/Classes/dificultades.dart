class Dificultades {
  int idDificultad;
  String descripcion;

  Dificultades({
    required this.idDificultad,
    required this.descripcion,
  });

  factory Dificultades.fromJson(Map<String, dynamic> json) {
    return Dificultades(
      idDificultad: json['idDificultad'],
      descripcion: json['descripcion'],
    );
  }
}