import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/rutinas.dart';

class EjercicioRutina {
  int idRutina;
  int idEjercicio;
  int series;
  int repeticiones;
  double? kilogramos;

  Rutina? rutina;
  Ejercicio? ejercicio;

  EjercicioRutina({
    required this.idRutina,
    required this.idEjercicio,
    required this.series,
    required this.repeticiones,
    this.kilogramos,
  });

  factory EjercicioRutina.fromJson(Map<String, dynamic> json) {
    return EjercicioRutina(
      idRutina: json['idRutina'],
      idEjercicio: json['idEjercicio'],
      series: json['series'],
      repeticiones: json['repeticiones'],
      kilogramos: json['kilogramos']?.toDouble(),
    );
  }
}