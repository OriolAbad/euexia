import 'package:euexia/app/services/service_tips.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/models/consejos.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;

class TipsController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var tips = <Consejos>[].obs; // Cambiado a RxList
  var tip = Consejos(idconsejo: 0, descripcion: '').obs;

  custom_response.Response result = custom_response.Response(success: false);

  @override
  void onInit() {
    super.onInit();
    getTips();
  }

  Future<void> getTips() async {
    isLoading.value = true;
    result = await _supabaseService.getTips();

    if(result.success){
      tips.assignAll(result.data as Iterable<Consejos>); // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;    
  }

  Future<void> getTipById(int id) async {
    isLoading.value = true;

    result = await _supabaseService.getTipById(id);

    if(result.success){
      tip.value = result.data as Consejos; // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  Future<void> addTip(Consejos tip) async {
    result = await _supabaseService.addTip(tip);
    if(result.success){
      tips.add(tip); // Agregar el consejo a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }

  Future<void> updateTip(Consejos tip) async {
    result = await _supabaseService.updateTip(tip);
    if(result.success){
      var index = tips.indexWhere((element) => element.idconsejo == tip.idconsejo);
      tips[index] = tip; // Actualizar el consejo en la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }

  Future<void> deleteTip(int id) async {
    result = await _supabaseService.deleteTip(id);
    if(result.success){
      tips.removeWhere((element) => element.idconsejo == id); // Eliminar el consejo de la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }
 
}
