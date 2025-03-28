import 'package:euexia/app/data/models/categorias.dart';
import 'package:euexia/app/data/models/fotos.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/models/consejos.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;

class TipsController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var tips = <Consejo>[].obs; // Cambiado a RxList
  var tip = Consejo(idconsejo: 0, descripcion: '').obs;

  custom_response.Response result = custom_response.Response(success: false);

  @override
  void onInit() {
    super.onInit();
    getTips();
    // var data = _supabaseService.

    }

  Future<void> getTips() async {
    isLoading.value = true;
    result = await _supabaseService.consejos.getTips();

    if(result.success){
      tips.assignAll(result.data as Iterable<Consejo>); // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;    
  }

  Future<void> getTipById(int id) async {
    isLoading.value = true;

    result = await _supabaseService.consejos.getTipById(id);

    if(result.success){
      tip.value = result.data as Consejo; // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  Future<void> addTip(Consejo tip) async {
    result = await _supabaseService.consejos.addTip(tip);
    if(result.success){
      tips.add(tip); // Agregar el consejo a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }

  Future<void> updateTip(Consejo tip) async {
    result = await _supabaseService.consejos.updateTip(tip);
    if(result.success){
      var index = tips.indexWhere((element) => element.idconsejo == tip.idconsejo);
      tips[index] = tip; // Actualizar el consejo en la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }

  Future<void> deleteTip(int id) async {
    result = await _supabaseService.consejos.deleteTip(id);
    if(result.success){
      tips.removeWhere((element) => element.idconsejo == id); // Eliminar el consejo de la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }
 
}
