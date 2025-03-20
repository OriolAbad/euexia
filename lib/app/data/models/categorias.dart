import 'package:euexia/app/data/models/ejercicios.dart';

class Categoria {
  int idCategoria;
  String nombre;

  List<Ejercicio>? ejercicios;

  Categoria({
    required this.idCategoria,
    required this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idcategoria'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idcategoria': idCategoria,
      'nombre': nombre,
    };
  }
}