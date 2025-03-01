class Categorias {
  int idCategoria;
  String nombre;

  Categorias({
    required this.idCategoria,
    required this.nombre,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
    );
  }
}