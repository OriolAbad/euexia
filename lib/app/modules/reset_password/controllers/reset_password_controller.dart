import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  var code = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  // Función para restablecer la contraseña
  Future<void> resetPassword() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      // Verifica el código OTP
      final authResponse = await Supabase.instance.client.auth.verifyOTP(
        token: code.value,
        type: OtpType.recovery,
      );

      if (authResponse.user == null) {
        Get.snackbar('Error', 'Invalid or expired OTP');
        return;
      }

      // Actualiza la contraseña
      final updateResponse = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password.value),
      );

      if (updateResponse.user != null) {
        Get.snackbar('Success', 'Password has been reset');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Error', 'Failed to update password');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
