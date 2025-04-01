import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import '../controllers/qr_controller.dart';

class QrView extends StatefulWidget {
  @override
  _QrViewState createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final QrController controller = Get.put(QrController());
  MobileScannerController? mobileScannerController;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: controller.isTorchOn.value,
      facing: controller.cameraFacing.value ? CameraFacing.back : CameraFacing.front,
    );
  }

  @override
  void dispose() {
    mobileScannerController?.dispose();
    super.dispose();
  }

  void _processScannedData(String? rawValue) {
    if (rawValue != null) {
      try {
        final userId = int.parse(rawValue);
        controller.updateUserId(userId);
        Get.snackbar(
          'Éxito',
          'ID de usuario escaneado: $userId',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'El código QR no contiene un ID de usuario válido',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.isTorchOn.value ? Icons.flash_on : Icons.flash_off,
            )),
            onPressed: () {
              controller.toggleTorch();
              mobileScannerController?.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () {
              controller.switchCamera();
              mobileScannerController?.switchCamera();
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: mobileScannerController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            _processScannedData(barcode.rawValue);
          }
        },
      ),
    );
  }
}