import 'package:euexia/app/data/models/categorias.dart';

class Ejercicio {
  int idEjercicio;
  String nombre;
  String? descripcion;
  int idCategoria;

  Categoria? categoria;

  Ejercicio({
    required this.idEjercicio,
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
    return {
      'idejercicio': idEjercicio,
      'nombre': nombre,
      'descripcion': descripcion,
      'idcategoria': idCategoria,
    };
  }
}