import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class TrainingsController extends GetxController{
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var trainings = [].obs;
  late Usuario usuario;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLoggedInUser();
    await getRutinas();
  }

  Future<void> getLoggedInUser() async {
    result = await _supabaseService.usuarios.getLoggedInUser();

    if(result.success){
      usuario = result.data as Usuario;
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
  }

  Future<void> getRutinas() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios_rutinas.getRutinasOfUser(usuario.idUsuario!);
    if(result.success){
      trainings.assignAll(result.data as Iterable); // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }
}