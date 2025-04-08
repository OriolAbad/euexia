import 'dart:async';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class StartTrainingController extends GetxController {
  final Rx<Rutina> rutina;
  var ejerciciosRutina = [].obs; // Lista de ejercicios de la rutina
  var currentExerciseIndex = 0.obs; // Índice del ejercicio actual
  var countdown = 3.obs; // Contador inicial
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var updating = false.obs;
  var adding = false.obs;

  var elapsedTime = 0.obs; // Tiempo transcurrido en segundos
  Timer? timer; // Timer para el contador

  StartTrainingController(Rutina rutina) : rutina = rutina.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    ejerciciosRutina.value = (rutina.value.ejercicios ?? []).cast<dynamic>(); // Asignar ejercicios de la rutina
  }

  void startCountdown(Function onCountdownComplete) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel(); // Detener el temporizador cuando llegue a 0
        onCountdownComplete(); // Llamar a la función pasada como callback
        startTimer(); // Iniciar el contador de tiempo
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value++;
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void nextExercise(Function onTrainingComplete) {
    if (currentExerciseIndex.value < ejerciciosRutina.length - 1) {
      currentExerciseIndex.value++;
    } else {
      stopTimer(); // Detener el temporizador al finalizar
      onTrainingComplete(); // Llamar a la función pasada como callback
    }
  }

  void reduceSeriesAndRest(int restTime, Function onRestComplete) {
    final currentExercise = ejerciciosRutina[currentExerciseIndex.value];
    if (currentExercise.series > 0) {
      currentExercise.series--; // Reducir el número de series
      ejerciciosRutina.refresh(); // Actualizar la lista para reflejar los cambios
    }

    // Iniciar el tiempo de descanso
    countdown.value = restTime;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel(); // Detener el temporizador cuando termine el descanso
        onRestComplete(); // Llamar al callback para continuar
      }
    });
  }

  @override
  void onClose() {
    stopTimer(); // Detener el temporizador al cerrar el controlador
    super.onClose();
  }
}