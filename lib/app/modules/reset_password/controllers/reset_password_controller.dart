import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

class ResetPasswordController extends GetxController {
  var code = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments; // Obtener el email pasado como argumento
  }

  // Función para restablecer la contraseña
  Future<void> resetPassword() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match',
        colorText: Colors.white, // Cambiar el color del texto a blanco
      );
      return;
    }

    isLoading.value = true;
    try {
      // Verifica el código OTP
      final authResponse = await Supabase.instance.client.auth.verifyOTP(
        email: email,
        token: code.value,
        type: OtpType.recovery,
      );

      if (authResponse.user == null) {
        Get.snackbar('Error', 'Invalid or expired OTP',
          colorText: Colors.white, // Cambiar el color del texto a blanco
        );
        return;
      }

      // Actualiza la contraseña
      final updateResponse = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password.value),
      );

      if (updateResponse.user != null) {
        Get.snackbar('Success', 'Password has been reset',
          colorText: Colors.white, // Cambiar el color del texto a blanco
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Error', 'Failed to update password',
          colorText: Colors.white, // Cambiar el color del texto a blanco
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
        colorText: Colors.white, // Cambiar el color del texto a blanco
      );
    } finally {
      isLoading.value = false;
    }
  }
}