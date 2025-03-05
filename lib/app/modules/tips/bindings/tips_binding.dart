import 'package:euexia/app/modules/tips/controllers/tips_controller.dart';
import 'package:get/get.dart';

class TipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TipsController>(
      () => TipsController(),
    );
  }
}
