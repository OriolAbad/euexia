import 'package:euexia/app/data/models/recompensas.dart';
import 'package:euexia/app/data/models/usuarios.dart';

class RecompensaCanjeada {
  int idRecompensa;
  int idUsuario;

  Usuario? usuario;
  Recompensa? recompensa;

  RecompensaCanjeada({
    required this.idRecompensa,
    required this.idUsuario
  });

  factory RecompensaCanjeada.fromJson(Map<String, dynamic> json) {
    return RecompensaCanjeada(
      idRecompensa: json['idrecompensa'],
      idUsuario: json['idusuario'],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'idrecompensa': idRecompensa,
      'idusuario': idUsuario,
    };
  }
}