import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  // Función para restablecer la contraseña
  Future<void> resetPassword() async {
    // Verificar si las contraseñas coinciden
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    // Activar el estado de carga
    isLoading.value = true;

    try {
      // Restablecer la contraseña
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password.value),
      );

      // Verificar la respuesta de Supabase
      if (response.user != null) {
        // Mostrar mensaje de éxito y redirigir al login
        Get.snackbar('Success', 'Password has been reset');
        Get.offAllNamed(Routes.LOGIN);  // Redirigir a la pantalla de login y eliminar otras pantallas
      } else {
        // Si no hay un usuario o hay un error, mostrar el mensaje de error
        Get.snackbar('Unknown error occurred', 'Please try again');
      }
    } catch (e) {
      // Manejo de cualquier error imprevisto
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      // Desactivar el estado de carga
      isLoading.value = false;
    }
  }
}
