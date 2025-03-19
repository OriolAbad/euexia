import 'package:euexia/app/data/models/dificultades.dart';
import 'package:euexia/app/data/models/tipos_retos.dart';

class Reto {
  int idReto;
  String titulo;
  String descripcion;
  int puntos;
  int idTipoReto;
  int idDificultad;

  TipoReto? tipoReto;
  Dificultad? dificultad;

  Reto({
    required this.idReto,
    required this.titulo,
    required this.descripcion,
    required this.puntos,
    required this.idTipoReto,
    required this.idDificultad,
  });

  factory Reto.fromJson(Map<String, dynamic> json) {
    return Reto(
      idReto: json['idReto'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntos: json['puntos'],
      idTipoReto: json['idTipoReto'],
      idDificultad: json['idDificultad'],
    );
  }
}