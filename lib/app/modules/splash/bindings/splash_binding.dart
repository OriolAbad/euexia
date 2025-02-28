import 'package:get/get.dart';
import '../controllers/splash_controller.dart'; // Ensure this file exists at the specified path

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}