import 'package:euexia/app/modules/trainings/controller/start_training_controller.dart';
import 'package:get/get.dart';

class StartTrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartTrainingController>(
      () => StartTrainingController(Get.arguments['rutina']),
    );
  }
}