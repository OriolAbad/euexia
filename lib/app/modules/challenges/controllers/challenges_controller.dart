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
  var retos = <UsuarioReto>[].obs;
  late int idUsuarioLogged = 0;

  custom_response.Response result = custom_response.Response(success: false);

  // Pomodoro
  Rx<int> currentTime = 0.obs;
  Rx<bool> isTimerRunning = false.obs;
  Rx<bool> isRetoCompleted = false.obs;

  // Nueva lógica para manejar series
  final int seriesTotales = 3;
  Rx<int> seriesCompletadas = 0.obs;
  final int descansoEntreSeries = 60;

  late UsuarioReto retoActual;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLoggedUser();
    await getRetosOfUser();
  }

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

  Future<void> getRetosOfUser() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios_retos.getUsuariosRetosByIdWithRetos(idUsuarioLogged);

    if (result.success) {
      retos.assignAll(result.data as Iterable<UsuarioReto>);
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;
  }

  void startReto(UsuarioReto usuarioReto, int durationInSeconds) {
    retoActual = usuarioReto;
    seriesCompletadas.value = 0;
    isRetoCompleted.value = false;
    startTimer(durationInSeconds);
  }

  void startTimer(int durationInSeconds) {
    currentTime.value = durationInSeconds;
    isTimerRunning.value = true;
    _runTimer();
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (currentTime.value > 0 && isTimerRunning.value) {
        currentTime.value -= 1;
        _runTimer();
      } else if (currentTime.value == 0 && isTimerRunning.value) {
        isTimerRunning.value = false;
        seriesCompletadas.value += 1;

        if (seriesCompletadas.value >= seriesTotales) {
          completeReto();
          isRetoCompleted.value = true;
        } else {
          // Espera antes de permitir siguiente serie
          Future.delayed(Duration(seconds: descansoEntreSeries), () {
            isRetoCompleted.value = true; // Marca disponible para siguiente serie
          });
        }
      }
    });
  }

  void nextSerie(int durationInSeconds) {
    isRetoCompleted.value = false;
    startTimer(durationInSeconds);
  }

  void pauseTimer() {
    isTimerRunning.value = false;
  }

  void resumeTimer() {
    isTimerRunning.value = true;
    _runTimer();
  }

  Future<void> completeReto() async {
    isLoading.value = true;

    result = await _supabaseService.usuarios_retos.updateUsuarioReto(UsuarioReto(
      idUsuario: idUsuarioLogged,
      idReto: retoActual.reto?.idReto ?? 0,
      completado: true,
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now(),
    ));

    if (result.success) {
      Get.snackbar("Éxito", "Reto completado");
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;
  }
}
