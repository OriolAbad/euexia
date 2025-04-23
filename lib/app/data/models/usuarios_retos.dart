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
      idReto: int.tryParse(json['idreto'].toString()) ?? 0,
      idUsuario: int.tryParse(json['idusuario'].toString()) ?? 0,
      fechaInicio: DateTime.parse(json['fechainicio']),
      fechaFin: json['fechafin'] != null ? DateTime.parse(json['fechafin']) : null,
      completado: json['completado'] ?? false,
    )..reto = json['retos'] != null ? Reto.fromJson(json['retos']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'idreto': idReto,
      'idusuario': idUsuario,
      'fechainicio': fechaInicio.toIso8601String(),
      'fechafin': fechaFin?.toIso8601String(),
      'completado': completado,
      'retos': reto?.toJson(), // Incluye el objeto Reto si existe
    };
  }
}