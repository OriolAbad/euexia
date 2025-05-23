import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(),
        permanent: true, // Clave para el Home
        tag: 'home' // Identificador único
        );
  }
}
