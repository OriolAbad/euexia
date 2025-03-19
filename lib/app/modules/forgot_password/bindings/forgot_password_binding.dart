import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart'; // Ensure this file exists at the specified path

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}