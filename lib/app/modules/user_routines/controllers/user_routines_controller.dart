import 'package:get/get.dart';
import 'package:euexia/app/services/service.dart'; // Importa el servicio
import 'package:flutter/material.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase

class UserRoutinesController extends GetxController {
  final SupabaseService _service = SupabaseService(); // Instancia del servicio
  var rutinas = [].obs; // Lista observable para almacenar las rutinas
  late int idUser; // Obtiene el id del usuario de los argumentos
  var savedRoutines = [].obs;

  @override
  void onInit() {
    super.onInit();
    idUser = Get.arguments; // Obtiene el id del usuario de los argumentos
    getRutinasOfUserWithExercises(
        idUser); // Llama a la función para obtener las rutinas del usuario
  }

  // Llama a la función del servicio para obtener las rutinas del usuario
  Future<void> getRutinasOfUserWithExercises(int userId) async {
    try {
      final response =
          await _service.usuarios_rutinas.getRutinasOfUserWithExercises(userId);
      if (response.data is Iterable) {
        rutinas.assignAll(response.data
            as Iterable); // Asigna las rutinas obtenidas a la lista observable
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las rutinas: $e');
    }
  }

  /* Logica para añadir una rutina de un amigo, Para hacer eso, 
  hay que copiar la rutina que haya seleccionado el usuario y 
  guardarsela a ese usuario, de esa manera, el usuario puede 
  modificarla a su manera y que si su amigo cambia los ejercicios,
  a él no se le cambiarán.
  También habría que hacer que el usuario marque las rutinas que 
  se quiere guardar y cuando salga de la pantalla, se le guarden,
  de esta manera si le da al boton de añadir y luego la elimina,
  no se le habrá guardado nada y las rutinas se guardarán 
  definitivamente al salir de la pantalla.
  */

  // EN LA VIEW HAY QUE HACER QUE SI EL BOTON ESTA EN ISSAVED SE GUARDE LA RUTINA EN
  // SAVEDROUTINES
  Future<void> saveAllSavedRoutines() async {
    for (Rutina routine in savedRoutines) {
      try {
        // Copia y guarda la rutina, obteniendo el ID de la nueva rutina
        int idNewRoutine = await copyAndSaveRoutine(routine);

        // Asocia la nueva rutina al usuario actual
        final response = await addToUsuariosRutinas(idNewRoutine, idUser);

        if (response.success) {
          Get.snackbar(
            'Éxito',
            'La rutina "${routine.nombre}" ha sido guardada correctamente.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(response.errorMessage);
        }
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

  Future<custom_response.Response> addToUsuariosRutinas(
      int idRutina, int idUsuario) async {
    final SupabaseClient client = Supabase.instance.client;
    custom_response.Response result = custom_response.Response(success: false);

    try {
      final response = await client.from('usuarios_rutinas').insert({
        'idusuario': idUsuario,
        'idrutina': idRutina,
        'publicada': false, // Establece publicada como false
      });

      if (response.error == null) {
        result.success = true;
        result.data = response.data;
      } else {
        result.success = false;
        result.errorMessage = response.error!.message;
      }
    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }

    return result;
  }

  Future<int> copyAndSaveRoutine(Rutina rutina) async {
    try {
      // Crear una nueva rutina basada en la rutina original
      final newRutina = Rutina(
        nombre: rutina.nombre,
        descripcion: rutina.descripcion,
        ejercicios: rutina.ejercicios, // Copia los ejercicios si es necesario
      );

      // Guardar la nueva rutina en la tabla "rutinas"
      final addRutinaResponse = await _service.rutinas.addRutina(newRutina);

      if (addRutinaResponse.success) {
        // Obtener el ID de la nueva rutina creada
        return addRutinaResponse.data['idRutina'];
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
