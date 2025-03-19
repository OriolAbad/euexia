import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class RecordPersonal {
  int idUsuario;
  int idEjercicio;
  double record;

  Usuario? usuario;
  Ejercicio? ejercicio;

  RecordPersonal({
    required this.idUsuario,
    required this.idEjercicio,
    required this.record,
  });

  factory RecordPersonal.fromJson(Map<String, dynamic> json) {
    return RecordPersonal(
      idUsuario: json['idUsuario'],
      idEjercicio: json['idEjercicio'],
      record: json['record'].toDouble(),
    );
  }
}