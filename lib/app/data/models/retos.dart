import 'package:euexia/app/data/models/dificultades.dart';
import 'package:euexia/app/data/models/tipos_retos.dart';

class Reto {
  int? idReto; // Ahora es opcional
  String titulo;
  String descripcion;
  int puntos;
  int idTipoReto;
  int idDificultad;

  TipoReto? tipoReto;
  Dificultad? dificultad;

  Reto({
    this.idReto, // No es obligatorio
    required this.titulo,
    required this.descripcion,
    required this.puntos,
    required this.idTipoReto,
    required this.idDificultad,
  });

  factory Reto.fromJson(Map<String, dynamic> json) {
    return Reto(
      idReto: json['idreto'] != null ? int.tryParse(json['idreto'].toString()) : null,
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntos: int.tryParse(json['puntos'].toString()) ?? 0,
      idTipoReto: int.tryParse(json['idtiporeto'].toString()) ?? 0,
      idDificultad: int.tryParse(json['iddificultad'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'titulo': titulo,
      'descripcion': descripcion,
      'puntos': puntos,
      'idtiporeto': idTipoReto,
      'iddificultad': idDificultad,
    };

    if (idReto != null) {
      data['idreto'] = idReto.toString();
    }

    return data;
  }
}
