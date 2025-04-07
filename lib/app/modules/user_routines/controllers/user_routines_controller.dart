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
    getRutinasOfUserWithExercises(idUser); // Llama a la función para obtener las rutinas del usuario
  }

  // Llama a la función del servicio para obtener las rutinas del usuario
  Future<void> getRutinasOfUserWithExercises(int userId) async {
    try {
      final response = await _service.usuarios_rutinas.getRutinasOfUserWithExercises(userId);
      if (response.data is Iterable) {
        rutinas.assignAll(response.data as Iterable); // Asigna las rutinas obtenidas a la lista observable
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las rutinas: $e');
    }
  }
}