import 'dart:async';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var retos = <UsuarioReto>[].obs;
  late int idUsuarioLogged = 0;

  custom_response.Response result = custom_response.Response(success: false);

  // Temporizador
  RxInt currentTime = 0.obs;
  RxBool isTimerRunning = false.obs;
  RxBool isRetoCompleted = false.obs;
  RxBool isTimerInitialized = false.obs;
  Timer? _timer;

  // Lógica de series
  final int seriesTotales = 3;
  RxInt seriesCompletadas = 0.obs;
  final int duracionRetoActual = 60; // solo se controla el descanso (60s)

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

  void startReto(UsuarioReto usuarioReto) {
    retoActual = usuarioReto;
    seriesCompletadas.value = 0;
    isRetoCompleted.value = false;
    startTimer();
  }

  void startRetoFromView(Reto reto) {
    final usuarioReto = retos.firstWhere((ur) => ur.reto?.idReto == reto.idReto);
    startReto(usuarioReto);
    isTimerInitialized.value = true;
  }

  void startTimer() {
    currentTime.value = duracionRetoActual;
    isTimerRunning.value = true;
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTime.value > 0 && isTimerRunning.value) {
        currentTime.value -= 1;
      } else if (currentTime.value == 0 && isTimerRunning.value) {
        timer.cancel();
        isTimerRunning.value = false;
        seriesCompletadas.value += 1;

        if (seriesCompletadas.value >= seriesTotales) {
          completeReto();
          isRetoCompleted.value = true;
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            isRetoCompleted.value = true;
          });
        }
      }
    });
  }

  void nextSerie() {
    isRetoCompleted.value = false;
    startTimer();
  }

  void pauseTimer() {
    isTimerRunning.value = false;
  }

  void resumeTimer() {
    if (currentTime.value > 0) {
      isTimerRunning.value = true;
      _runTimer();
    }
  }

  void resetPomodoro() {
    if (isTimerInitialized.value && seriesCompletadas.value < seriesTotales) {
      _timer?.cancel();
      currentTime.value = duracionRetoActual;
      seriesCompletadas.value = 0;
      isTimerRunning.value = false;
      isTimerInitialized.value = false;
      isRetoCompleted.value = false;
    }
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
