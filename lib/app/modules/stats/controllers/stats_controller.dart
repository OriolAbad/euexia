import 'package:euexia/app/data/models/records_personales.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/services/service.dart';

class StatsController extends GetxController {
  final _supabaseService = SupabaseService();
  var isLoading = false.obs;
  var records = <RecordPersonal>[].obs;
  late int idUsuarioLogged = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLoggedUser();
    await getPersonalRecords();
  }

  Future<void> getLoggedUser() async {
    isLoading.value = true;
    final result = await _supabaseService.usuarios.getLoggedInUser();

    if (result.success) {
      Usuario loggedUser = result.data as Usuario;
      idUsuarioLogged = loggedUser.idUsuario!;
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  Future<void> getPersonalRecords() async {
    isLoading.value = true;
    final result = await _supabaseService.records_personales.getRecordsPersonalesByUserIdWithExercise(idUsuarioLogged);

    if (result.success) {
      records.assignAll(result.data as List<RecordPersonal>);
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Error al cargar records");
    }
    isLoading.value = false;
  }
}