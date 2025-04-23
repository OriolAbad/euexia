// controllers/challenges_controller.dart
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var retos = [].obs;
  late int idUsuarioLogged = 0;

  custom_response.Response result = custom_response.Response(success: false);

  // Variables para el control del tiempo y el estado del reto
  Rx<int> currentTime = 0.obs;
  Rx<bool> isTimerRunning = false.obs;
  Rx<bool> isRetoCompleted = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getLoggedUser();
    await getRetosOfUser();
  }

  // Función para obtener el usuario logueado
  Future<void> getLoggedUser() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios.getLoggedInUser();

    if (result.success) {
      Usuario loggedUser = result.data as Usuario;
      idUsuarioLogged = loggedUser.idUsuario!;
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;
  }

  // Función para obtener los retos del usuario
  Future<void> getRetosOfUser() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios_retos.getUsuariosRetosByIdWithRetos(idUsuarioLogged);

    if (result.success) {
      retos.assignAll(result.data as Iterable<UsuarioReto>); // Asignar correctamente los datos a la lista observable
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;
  }

  // Función para iniciar el timer (pomodoro)
  void startTimer(int durationInSeconds) {
    currentTime.value = durationInSeconds;
    isTimerRunning.value = true;
    _runTimer();
  }

  // Lógica para el ciclo del timer
  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (currentTime.value > 0 && isTimerRunning.value) {
        currentTime.value -= 1;
        _runTimer();
      } else if (currentTime.value == 0) {
        // Cuando el tiempo llega a 0, termina el bloque de la serie
        isTimerRunning.value = false;
        isRetoCompleted.value = true;
        // Aquí deberíamos actualizar el reto en Supabase
        completeReto();
      }
    });
  }

  // Función para completar el reto
  Future<void> completeReto() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios_retos.updateUsuarioReto(UsuarioReto(
      idUsuario: idUsuarioLogged,
      idReto: retos[0].reto?.idReto ?? 0, // Asegúrate de obtener el ID correcto
      completado: true,
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now(),
    ));

    if (result.success) {
      Get.snackbar("Éxito", "Reto completado");
      // Puedes actualizar la lista de retos si es necesario
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;
  }

  // Función para marcar el siguiente bloque (si hay más series)
  void nextSerie(int durationInSeconds) {
    isRetoCompleted.value = false;
    startTimer(durationInSeconds);
  }

  // Función para pausar el timer
  void pauseTimer() {
    isTimerRunning.value = false;
  }

  // Función para reanudar el timer
  void resumeTimer() {
    isTimerRunning.value = true;
    _runTimer();
  }
}
