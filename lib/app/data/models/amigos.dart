import 'package:euexia/app/data/models/usuarios.dart';

class Amigo {
  int idUsuario1;
  int idUsuario2;

  Usuario? usuario1;
  Usuario? usuario2;

  Amigo({
    required this.idUsuario1,
    required this.idUsuario2,
  });

  factory Amigo.fromJson(Map<String, dynamic> json) {
    return Amigo(
      idUsuario1: json['idUsuario1'],
      idUsuario2: json['idUsuario2'],
    );
  }
}