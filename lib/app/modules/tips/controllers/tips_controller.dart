import 'package:euexia/app/services/service_tips.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/models/consejos.dart';

class TipsController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var tips = <Consejos>[].obs; // Cambiado a RxList
  var tip = Consejos(idconsejo: 0, descripcion: '').obs;

  @override
  void onInit() {
    super.onInit();
    getTips();
    // getTipById(2);
    // addTip(newtip.value);
  }

  Future<void> getTips() async {
    isLoading.value = true;
    
    try {
      var fetchedTips = await _supabaseService.getTips();
      tips.assignAll(fetchedTips); // Asignar correctamente los datos a la lista observable
    } catch (e) {
      Get.snackbar("Error", "No se pudieron cargar los consejos");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTipById(int id) async {
    isLoading.value = true;
    
    try {
      var fetchedTip = await _supabaseService.getTipById(id);
      tip.value = fetchedTip; // Asignar correctamente los datos a la lista observable
    } catch (e) {
      Get.snackbar("Error", "No se pudo cargar el consejo");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTip(Consejos tip) async {
    try {
      await _supabaseService.addTip(tip);
      tips.add(tip); // Agregar el consejo a la lista observable
    } catch (e) {
      Get.snackbar("Error", "No se pudo agregar el consejo");
    }
  }

  Future<void> updateTip(Consejos tip) async {
    try {
      await _supabaseService.updateTip(tip);
      var index = tips.indexWhere((element) => element.idconsejo == tip.idconsejo);
      tips[index] = tip; // Actualizar el consejo en la lista observable
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el consejo");
    }
  }

  Future<void> deleteTip(int id) async {
    try {
      await _supabaseService.deleteTip(id);
      tips.removeWhere((element) => element.idconsejo == id); // Eliminar el consejo de la lista observable
    } catch (e) {
      Get.snackbar("Error", "No se pudo eliminar el consejo");
    }
  }
 
}
