// lib/bindings/profile_binding.dart
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
//import '../stats/controllers/stats_controller.dart';
//import '../gallery/controllers/gallery_controller.dart';
//import '../gallery/controllers/account_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
   // Get.lazyPut<StatsController>(() => StatsController());
    //Get.lazyPut<GalleryController>(() => GalleryController());
    //Get.lazyPut<AccountController>(() => AccountController());
  }
}



