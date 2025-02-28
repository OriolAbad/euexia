import 'package:get/get.dart';

class SplashController extends GetxController {
  // Add your variables and methods here

  @override
  void onInit() {
    super.onInit();
    // Initialize your variables or call your methods here
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
  }

  @override
  void onClose() {
    // Clean up resources here
    super.onClose();
  }

  // Example method
  void navigateToHome() {
    // Logic to navigate to the home page
    Get.offAllNamed('/home');
  }
}