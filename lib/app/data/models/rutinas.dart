import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';

class Rutina {
  int? idRutina; // Ahora es opcional
  String nombre;
  String? descripcion;
  List<EjercicioRutina>? ejercicios;

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
              .map((e) => EjercicioRutina.fromJson({
                    ...e,
                    'ejercicio': e['ejercicio'] != null
                        ? Ejercicio.fromJson(e['ejercicio']).toJson()
                        : null,
                  }))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'nombre': nombre,
      'descripcion': descripcion,
    };

    if (idRutina != null) {
      data['idrutina'] = idRutina.toString();
    }
    return data;
  }
}
