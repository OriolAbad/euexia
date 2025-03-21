class Recompensa {
  int? idRecompensa; // Ahora es opcional
  String nombre;
  String descripcion;
  int puntosNecesarios;

  Recompensa({
    this.idRecompensa, // No es obligatorio
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
    final data = {
      'nombre': nombre,
      'descripcion': descripcion,
      'puntosnecesarios': puntosNecesarios,
    };

    if (idRecompensa != null) {
      data['idrecompensa'] = idRecompensa.toString();
    }

    return data;
  }
}
