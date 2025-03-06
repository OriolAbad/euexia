import 'package:get/get.dart';

import '../controllers/stats_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatsController>(
      () => StatsController(),
    );
  }
}
