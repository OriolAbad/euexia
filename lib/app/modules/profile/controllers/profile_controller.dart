import 'package:get/get.dart';
import 'package:euexia/app/services/service.dart'; // Importa el servicio de Supabase
import 'package:euexia/app/data/models/usuarios.dart'; // Importa el modelo Usuario
import 'package:euexia/app/data/help/response.dart' as custom_response;

class ProfileController extends GetxController {
  final _supabaseService = SupabaseService(); // Instancia del servicio Supabase
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs; // Variable observable para el estado de carga
  var username = "".obs; // Variable observable para el nombre del usuario
  late Usuario usuario; // Variable para almacenar el usuario autenticado

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLoggedInUser(); // Llama al método para obtener el usuario autenticado
  }

  Future<void> getLoggedInUser() async {
    isLoading.value = true; // Activa el estado de carga
    result = await _supabaseService.usuarios.getLoggedInUser(); // Llama al servicio

    if (result.success && result.data != null) {
      usuario = result.data as Usuario; // Mapea los datos al modelo Usuario
      username.value = usuario.nombreUsuario; // Asigna el nombre del usuario
    } else {
      username.value = "User"; // Valor predeterminado si no hay usuario
    }
    isLoading.value = false; // Desactiva el estado de carga
  }
}