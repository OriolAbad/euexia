import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';


class SingTrainingController extends GetxController {
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var selectedRutina = Rutina(nombre: '').obs;
  var newEjercicioRutina = EjercicioRutina(
    idRutina: 0, // Replace with appropriate default or dynamic value
    idEjercicio: 0, // Replace with appropriate default or dynamic value
    series: 0, // Replace with appropriate default or dynamic value
    repeticiones: 0, // Replace with appropriate default or dynamic value
  ).obs;

  late int trainingId; // Declarar el trainingId como variable de instancia
  SingTrainingController(this.trainingId); // Constructor para recibir el trainingId

  @override
  Future<void> onInit() async {
    super.onInit();
    await getRutinaWithEjercicios();
  }

  Future<void> getRutinaWithEjercicios() async {
    isLoading.value = true;
    result = await _supabaseService.rutinas.getRutinaWithEjercicios(trainingId);

    if (result.success) {
      selectedRutina.value = result.data as Rutina; // Asignar correctamente los datos a la rutina observable
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  Future<void> addEjercicioToRutina() async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios_rutinas.addEjercicioRutina(newEjercicioRutina.value);
    
    if (!result.success) {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    selectedRutina.value.ejercicios!.add(newEjercicioRutina.value);
    isLoading.value = false;
  }
}