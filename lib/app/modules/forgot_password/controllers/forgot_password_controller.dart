import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController extends GetxController {
  var email = ''.obs;
  var isLoading = false.obs;

  final SupabaseClient client = Supabase.instance.client;

  void sendPasswordResetEmail() async {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Error', 'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validar formato de email
    if (!GetUtils.isEmail(email.value)) {
      Get.snackbar(
        'Error', 'Invalid email format',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    try {
      await client.auth.resetPasswordForEmail(email.value);

      Get.snackbar(
        'Success', 'Password reset email sent!',
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
