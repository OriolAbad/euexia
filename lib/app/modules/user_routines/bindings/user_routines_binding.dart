// lib/bindings/challenges_binding.dart
import 'package:get/get.dart';
import '../controllers/user_routines_controller.dart';

class UserRoutinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRoutinesController>(() => UserRoutinesController());
  }
}
