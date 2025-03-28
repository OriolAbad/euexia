import 'package:get/get.dart';

class QrController extends GetxController {
  var userId = 0.obs;
  var isTorchOn = false.obs;
  var cameraFacing = true.obs; // true = back, false = front

  void updateUserId(int id) {
    userId.value = id;
  }

  void toggleTorch() {
    if (cameraFacing.value) { // Solo permitir en cámara trasera
      isTorchOn.toggle();
    }
  }

  void switchCamera() {
    cameraFacing.toggle();
    if (!cameraFacing.value) { // Si cambia a frontal
      isTorchOn.value = false; // Apagar flash
    }
  }
}