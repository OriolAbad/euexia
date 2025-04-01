import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/modules/home/controllers/home_controller.dart';
import 'package:euexia/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Simula la carga de datos o realiza cualquier inicialización necesaria
      await Future.delayed(Duration(seconds: 2));

      // Redirige según el estado de autenticación
      final supaProvider = Supabase.instance.client;
      if (supaProvider.auth.currentUser == null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al inicializar la aplicación: $e');
    }
    finally {
      _isLoading.value = false;
    }
  }

  void redirectToAppropriateScreen() {
    final supaProvider = Supabase.instance.client;
    if (supaProvider.auth.currentUser == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {
    // Limpiar recursos si es necesario
    super.onClose();
  }
}