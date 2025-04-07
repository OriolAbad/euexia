import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/modules/trainings/controller/start_training_controller.dart';
import 'package:get/get.dart';

class StartTrainingBinding extends Bindings {
  final Rutina rutina;

  StartTrainingBinding(this.rutina);

  @override
  void dependencies() {
    Get.lazyPut<StartTrainingController>(() => StartTrainingController(rutina));
  }
}