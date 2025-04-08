import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_rutinas.dart';
import 'package:get/get.dart';
import 'package:euexia/app/services/service.dart'; // Importa el servicio
import 'package:flutter/material.dart';
import 'package:euexia/app/data/models/rutinas.dart';

class UserRoutinesController extends GetxController {
  final SupabaseService _service = SupabaseService(); // Instancia del servicio
  var rutinas = [].obs; // Lista observable para almacenar las rutinas
  late int idUser; // Obtiene el id del usuario de los argumentos
  late int idLogggedUser;
  var savedRoutines = [].obs;
  var idNewRutina;

  @override
  Future<void> onInit() async {
    super.onInit();
    idUser = Get.arguments; // Obtiene el id del usuario de los argumentos

    await getNumberOfRutinas();
    await getLoggedUserId(); // Obtiene el id del usuario logueado
    await getRutinasOfUserWithExercises(); // Llama a la función para obtener las rutinas del usuario,
  }

  Future<void> getNumberOfRutinas() async {
    var response = await _service.rutinas.getNumberOfRutinas();
    if (response.success) {
      idNewRutina = response.data;
      idNewRutina++;
    } else {
      Get.snackbar('Error', 'No se pudo obtener el ID de la rutina');
    } // Obtiene el id de la nueva rutina de los argumentos
  }

  Future<void> getLoggedUserId() async {
    var response = await _service.usuarios.getLoggedInUser();
    if (response.success) {
      Usuario user = response.data as Usuario;
      idLogggedUser =
          user.idUsuario!; // Asigna el id del usuario a la variable idUser
    } else {
      Get.snackbar('Error', 'No se pudo obtener el ID del usuario');
    }
  }

  Future<void> getRutinasOfUserWithExercises() async {
    var response =
        await _service.usuarios_rutinas.getRutinasOfUserWithExercises(idUser);

    // Verifica si la respuesta es válida
    if (response.success) {
      rutinas.assignAll(response.data
          as Iterable); // Asigna las rutinas obtenidas a la lista observable
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<void> saveAllSavedRoutines() async {
    for (Rutina routine in savedRoutines) {
      try {
        // Copia y guarda la rutina, obteniendo el ID de la nueva rutina
        await copyAndSaveRoutine(routine);
      } catch (e) {
        Get.snackbar(
          'Error',
          'No se pudo guardar la rutina "${routine.nombre}": $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> copyAndSaveRoutine(Rutina rutina) async {
    try {
      // Crear una nueva rutina basada en la rutina original
      final newRutina = Rutina(
        idRutina: idNewRutina,
        nombre: rutina.nombre,
        descripcion: rutina.descripcion,
        ejercicios: rutina.ejercicios, // Copia los ejercicios si es necesario
      );

      // Guardar la nueva rutina en la tabla "rutinas"
      final addRutinaResponse = await _service.rutinas.addRutina(newRutina);

      if (addRutinaResponse.success) {
        // Obtener el ID de la nueva rutina
        UsuarioRutina usuarioRutina = UsuarioRutina(
          idUsuario: idLogggedUser,
          idRutina: idNewRutina,
          publicada: false, // Establece publicada como false
        );
        var response =
            await _service.usuarios_rutinas.addUsuarioRutina(usuarioRutina);
        if (response.success) {
          if (rutina.ejercicios != null) {
            for (var ejercicio_rutina in rutina.ejercicios!) {
              // Copia los ejercicios de la rutina original a la nueva rutina
              final newEjercicioRutina = EjercicioRutina(
                idRutina: newRutina.idRutina!,
                idEjercicio: ejercicio_rutina.idEjercicio,
                series: ejercicio_rutina.series,
                repeticiones: ejercicio_rutina.repeticiones,
                kilogramos: ejercicio_rutina.kilogramos,
              );
              var response = await _service.ejercicios_rutinas
                  .addEjercicioRutina(newEjercicioRutina);

              if (!response.success) {
                Get.snackbar(
                  'Error',
                  'No se pudo guardar el ejercicio de la rutina: ${response.errorMessage}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            }
          }

          idNewRutina++;
        } else {
          Get.snackbar(
            'Error',
            'No se pudo guardar la rutina: ${response.errorMessage}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception(addRutinaResponse.errorMessage);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo copiar y guardar la rutina: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow; // Lanza el error para que sea manejado por el método que lo llama
    }
  }
}
