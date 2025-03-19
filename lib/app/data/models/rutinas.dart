class Rutina {
  int idRutina;
  String nombre;
  String? descripcion;

  Rutina({
    required this.idRutina,
    required this.nombre,
    this.descripcion,
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      idRutina: json['idrutina'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idrutina': idRutina,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}