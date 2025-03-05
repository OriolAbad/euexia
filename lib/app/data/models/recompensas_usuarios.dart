class RecompensasUsuarios {
  int idRecompensa;
  int idUsuario;
  bool canjeada;

  RecompensasUsuarios({
    required this.idRecompensa,
    required this.idUsuario,
    this.canjeada = false,
  });

  factory RecompensasUsuarios.fromJson(Map<String, dynamic> json) {
    return RecompensasUsuarios(
      idRecompensa: json['idRecompensa'],
      idUsuario: json['idUsuario'],
      canjeada: json['canjeada'] ?? false,
    );
  }
}