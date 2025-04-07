import 'package:get/get.dart';
import 'package:euexia/app/services/service.dart'; // Importa el servicio

class UserRoutinesController extends GetxController {
  final SupabaseService _service = SupabaseService(); // Instancia del servicio
  var rutinas = [].obs; // Lista observable para almacenar las rutinas
  late int idUser; // Obtiene el id del usuario de los argumentos

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


  /* Lógica para no guardar la rutina de mi amigo al final
  al hacer click en el botón, se quitará la rutina de la lista
  de rutinas que hay que guardar*/

}
