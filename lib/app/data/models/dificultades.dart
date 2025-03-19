class Dificultad {
  int idDificultad;
  String descripcion;

  Dificultad({
    required this.idDificultad,
    required this.descripcion,
  });

  factory Dificultad.fromJson(Map<String, dynamic> json) {
    return Dificultad(
      idDificultad: json['iddificultad'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iddificultad': idDificultad,
      'descripcion': descripcion,
    };
  }
}