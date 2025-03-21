import 'package:euexia/app/data/models/categorias.dart';

class Ejercicio {
  int? idEjercicio; // Ahora es opcional
  String nombre;
  String? descripcion;
  int idCategoria;

  Categoria? categoria;

  Ejercicio({
    this.idEjercicio, // No es obligatorio
    required this.nombre,
    this.descripcion,
    required this.idCategoria,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      idEjercicio: json['idejercicio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      idCategoria: json['idcategoria'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'nombre': nombre,
      'descripcion': descripcion,
      'idcategoria': idCategoria,
    };

    if (idEjercicio != null) {
      data['idejercicio'] = idEjercicio;
    }

    return data;
  }
}
