import 'package:euexia/app/data/models/ejercicios.dart';

class Rutina {
  int? idRutina; // Ahora es opcional
  String nombre;
  String? descripcion;
  List<Ejercicio>? ejercicios;

  Rutina({
    this.idRutina, // No es obligatorio
    required this.nombre,
    this.descripcion,
    this.ejercicios,
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      idRutina: json['idrutina'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      ejercicios: json['ejercicios'] != null
          ? (json['ejercicios'] as List)
              .map((e) => Ejercicio.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'nombre': nombre,
      'descripcion': descripcion,
      'ejercicios': ejercicios?.map((e) => e.toJson()).toList(),
    };

    if (idRutina != null) {
      data['idrutina'] = idRutina;
    }

    return data;
  }
}
