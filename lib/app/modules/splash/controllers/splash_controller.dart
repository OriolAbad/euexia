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
      // Precargar el controlador de Home y sus datos
      Get.put(HomeController(), permanent: true, tag: 'home');
      final homeController = Get.find<HomeController>(tag: 'home');
      
      // Cargar datos en paralelo para mayor eficiencia
      await Future.wait([
        homeController.fetchUserQrData(),
        homeController.fetchFeaturedTips(),
      ]);

      
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar los datos');
    } finally {
      _isLoading.value = false;
      _redirectToAppropriateScreen();
    }
  }

  void _redirectToAppropriateScreen() {
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