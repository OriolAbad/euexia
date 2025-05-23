import 'package:euexia/app/data/models/ejercicios.dart';

class Categoria {
  int? idCategoria;
  String nombre;

  List<Ejercicio>? ejercicios;

  Categoria({
    this.idCategoria, // Ahora es opcional
    required this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idcategoria'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'nombre': nombre,
    };

    if (idCategoria != null) {
      data['idcategoria'] = idCategoria.toString();
    }

    return data;
  }
}
