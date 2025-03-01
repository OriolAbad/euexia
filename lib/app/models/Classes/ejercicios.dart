class Ejercicios {
  int idEjercicio;
  String nombre;
  String? descripcion;
  int idCategoria;

  Ejercicios({
    required this.idEjercicio,
    required this.nombre,
    this.descripcion,
    required this.idCategoria,
  });

  factory Ejercicios.fromJson(Map<String, dynamic> json) {
    return Ejercicios(
      idEjercicio: json['idEjercicio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      idCategoria: json['idCategoria'],
    );
  }
}