import 'package:euexia/app/data/models/usuarios.dart';

class RecompensaUsuario {
  int idRecompensa;
  int idUsuario;
  bool canjeada;

  Usuario? usuario;

  RecompensaUsuario({
    required this.idRecompensa,
    required this.idUsuario,
    this.canjeada = false,
  });

  factory RecompensaUsuario.fromJson(Map<String, dynamic> json) {
    return RecompensaUsuario(
      idRecompensa: json['idRecompensa'],
      idUsuario: json['idUsuario'],
      canjeada: json['canjeada'] ?? false,
    );
  }
}