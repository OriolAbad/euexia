import 'package:euexia/app/modules/trainings/controller/trainings_controller.dart';
import 'package:get/get.dart';

class TrainingsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TrainingsController>(() => TrainingsController());
  } 
}