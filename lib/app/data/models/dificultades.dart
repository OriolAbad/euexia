class Dificultad {
  int? idDificultad; // Ahora es opcional
  String descripcion;

  Dificultad({
    this.idDificultad, // No es obligatorio
    required this.descripcion,
  });

  factory Dificultad.fromJson(Map<String, dynamic> json) {
    return Dificultad(
      idDificultad: json['iddificultad'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'descripcion': descripcion,
    };

    if (idDificultad != null) {
      data['iddificultad'] = idDificultad.toString();
    }

    return data;
  }
}
