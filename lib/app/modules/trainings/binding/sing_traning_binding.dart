import 'package:euexia/app/modules/trainings/controller/sing_training_controller.dart';
import 'package:get/get.dart';

class TrainingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingTrainingController>(
      () => SingTrainingController(Get.arguments['trainingId']),
    );
  }
}