import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class DiaEntrenado {
  int idUsuario;
  int idRutina;
  DateTime fechaEntrenamiento;
  Duration tiempoEntrenamiento;

  Usuario? usuario;
  Rutina? rutina;

  DiaEntrenado({
    required this.idUsuario,
    required this.idRutina,
    required this.fechaEntrenamiento,
    required this.tiempoEntrenamiento,
  });

  factory DiaEntrenado.fromJson(Map<String, dynamic> json) {
    return DiaEntrenado(
      idUsuario: json['idusuario'],
      idRutina: json['idrutina'],
      fechaEntrenamiento: DateTime.parse(json['fechaEntrenamiento']),
      tiempoEntrenamiento: Duration(
        hours: int.parse(json['tiempoEntrenamiento'].split(':')[0]),
        minutes: int.parse(json['tiempoEntrenamiento'].split(':')[1]),
        seconds: int.parse(json['tiempoEntrenamiento'].split(':')[2]),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idUsuario,
      'idrutina': idRutina,
      'fechaEntrenamiento': fechaEntrenamiento.toIso8601String(),
      'tiempoEntrenamiento': '${tiempoEntrenamiento.inHours.toString().padLeft(2, '0')}:'
          '${(tiempoEntrenamiento.inMinutes % 60).toString().padLeft(2, '0')}:'
          '${(tiempoEntrenamiento.inSeconds % 60).toString().padLeft(2, '0')}',
    };
  }
}