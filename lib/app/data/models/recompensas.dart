class Recompensa {
  int idRecompensa;
  String nombre;
  String descripcion;
  int puntosNecesarios;

  Recompensa({
    required this.idRecompensa,
    required this.nombre,
    required this.descripcion,
    required this.puntosNecesarios,
  });

  factory Recompensa.fromJson(Map<String, dynamic> json) {
    return Recompensa(
      idRecompensa: json['idrecompensa'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      puntosNecesarios: json['puntosnecesarios'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idrecompensa': idRecompensa,
      'nombre': nombre,
      'descripcion': descripcion,
      'puntosnecesarios': puntosNecesarios,
    };
  }
}