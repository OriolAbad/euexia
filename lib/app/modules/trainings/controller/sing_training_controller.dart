import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';


class SingTrainingController extends GetxController {
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var ejercicios = [].obs;

  late int trainingId; // Declarar el trainingId como variable de instancia

  SingTrainingController(this.trainingId); // Constructor para recibir el trainingId

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEjercicios();
  }

  Future<void> getEjercicios() async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios_rutinas.getEjerciciosByRutinaIdWithEjercicios(trainingId);
    if (result.success) {
      ejercicios.assignAll(result.data as Iterable); // Asignar correctamente los datos a la lista observable
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }
}