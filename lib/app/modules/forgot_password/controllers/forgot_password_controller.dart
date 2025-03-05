import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController extends GetxController {
  var email = ''.obs;
  var isLoading = false.obs;

  final SupabaseClient client = Supabase.instance.client;

  void sendPasswordResetEmail() async {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Error', 'Por favor, ingresa tu correo electrónico',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validar formato de email
    if (!GetUtils.isEmail(email.value)) {
      Get.snackbar(
        'Error', 'Formato de email no válido',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    try {
      await client.auth.resetPasswordForEmail(email.value);

      Get.snackbar(
        'Éxito', '¡Correo de recuperación enviado!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false; 
    }
  }
}
