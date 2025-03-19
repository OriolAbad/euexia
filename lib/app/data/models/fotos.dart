import 'package:euexia/app/data/models/usuarios.dart';

class Foto {
  int idFoto;
  String urlFoto;
  int idUsuario;
  
  Usuario? usuario;

  Foto({
    required this.idFoto,
    required this.urlFoto,
    required this.idUsuario,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      idFoto: json['idfoto'],
      urlFoto: json['urlfoto'],
      idUsuario: json['idusuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idfoto': idFoto,
      'urlfoto': urlFoto,
      'idusuario': idUsuario,
    };
  }
}