import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class UsuarioRutina {
  int idUsuario;
  int idRutina;
  bool publicada;

  Usuario? usuario;
  Rutina? rutina;

  UsuarioRutina({
    required this.idUsuario,
    required this.idRutina,
    this.publicada = false,
  });

  factory UsuarioRutina.fromJson(Map<String, dynamic> json) {
    return UsuarioRutina(
      idUsuario: json['idUsuario'],
      idRutina: json['idRutina'],
      publicada: json['publicada'] ?? false,
    );
  }
}