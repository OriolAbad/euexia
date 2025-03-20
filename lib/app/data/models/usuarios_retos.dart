import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class UsuarioReto {
  int idReto;
  int idUsuario;
  DateTime fechaInicio;
  DateTime? fechaFin;
  bool completado;

  Reto? reto;
  Usuario? usuario;

  UsuarioReto({
    required this.idReto,
    required this.idUsuario,
    required this.fechaInicio,
    this.fechaFin,
    this.completado = false,
  });

  factory UsuarioReto.fromJson(Map<String, dynamic> json) {
    return UsuarioReto(
      idReto: json['idreto'],
      idUsuario: json['idusuario'],
      fechaInicio: DateTime.parse(json['fechainicio']),
      fechaFin: json['fechafin'] != null ? DateTime.parse(json['fechafin']) : null,
      completado: json['completado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idreto': idReto,
      'idusuario': idUsuario,
      'fechainicio': fechaInicio.toIso8601String(),
      'fechafin': fechaFin?.toIso8601String(),
      'completado': completado,
    };
  }
}