import 'package:euexia/app/data/models/usuarios.dart';

class Foto {
  int? idFoto; // Ahora es opcional
  String urlFoto;
  int idUsuario;

  Usuario? usuario;

  Foto({
    this.idFoto, // No es obligatorio
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
    final data = {
      'urlfoto': urlFoto,
      'idusuario': idUsuario,
    };

    if (idFoto != null) {
      data['idfoto'] = idFoto.toString();
    }

    return data;
  }
}
