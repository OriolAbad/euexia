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
      idReto: json['idReto'],
      idUsuario: json['idUsuario'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
      completado: json['completado'] ?? false,
    );
  }
}