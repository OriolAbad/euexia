class Rutinas {
  int idEjercicio;
  String nombre;
  String? descripcion;
  int idCategoria;

  Rutinas({
    required this.idEjercicio,
    required this.nombre,
    this.descripcion,
    required this.idCategoria,
  });

  factory Rutinas.fromJson(Map<String, dynamic> json) {
    return Rutinas(
      idEjercicio: json['idEjercicio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      idCategoria: json['idCategoria'],
    );
  }
}