class Recompensas {
  int idRecompensa;
  String nombre;
  String descripcion;
  int puntosNecesarios;

  Recompensas({
    required this.idRecompensa,
    required this.nombre,
    required this.descripcion,
    required this.puntosNecesarios,
  });

  factory Recompensas.fromJson(Map<String, dynamic> json) {
    return Recompensas(
      idRecompensa: json['idRecompensa'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      puntosNecesarios: json['puntosNecesarios'],
    );
  }
}