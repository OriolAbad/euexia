class EjerciciosRutina {
  int idRutina;
  int idEjercicio;
  int series;
  int repeticiones;
  double? kilogramos;

  EjerciciosRutina({
    required this.idRutina,
    required this.idEjercicio,
    required this.series,
    required this.repeticiones,
    this.kilogramos,
  });

  factory EjerciciosRutina.fromJson(Map<String, dynamic> json) {
    return EjerciciosRutina(
      idRutina: json['idRutina'],
      idEjercicio: json['idEjercicio'],
      series: json['series'],
      repeticiones: json['repeticiones'],
      kilogramos: json['kilogramos']?.toDouble(),
    );
  }
}