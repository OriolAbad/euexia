import 'package:euexia/app/data/models/gimnasios.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class UsuarioGimnasio {
  int idUsuario;
  int idGimnasio;
  bool favorito;

  Usuario? usuario;
  Gimnasio? gimnasio;

  UsuarioGimnasio({
    required this.idUsuario,
    required this.idGimnasio,
    this.favorito = false,
  });

  factory UsuarioGimnasio.fromJson(Map<String, dynamic> json) {
    return UsuarioGimnasio(
      idUsuario: json['idusuario'],
      idGimnasio: json['idgimnasio'],
      favorito: json['favorito'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idUsuario,
      'idgimnasio': idGimnasio,
      'favorito': favorito,
    };
  }
}