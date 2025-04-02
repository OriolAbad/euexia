import 'package:euexia/app/modules/exercises/controllers/exercises_controller.dart';
import 'package:get/get.dart';

class ExercisesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisesController>(() => ExercisesController());
  }
}