import 'dart:async';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RetoState {
  final int duracionRetoActual;
  final int seriesTotales;
  
  RxInt currentTime = 0.obs;
  RxBool isTimerRunning = false.obs;
  RxBool isRetoCompleted = false.obs;
  RxInt seriesCompletadas = 0.obs;
  Timer? _timer;

  RetoState({required this.duracionRetoActual, required this.seriesTotales});

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
        isRetoCompleted.value = true;
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

  void reset() {
    _timer?.cancel();
    currentTime.value = duracionRetoActual;
    seriesCompletadas.value = 0;
    isTimerRunning.value = false;
    isRetoCompleted.value = false;
  }

  void dispose() {
    _timer?.cancel();
  }
}

class ChallengesController extends GetxController {
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var retos = <UsuarioReto>[].obs;
  late int idUsuarioLogged = 0;
  final int seriesTotales = 3;
  final int duracionRetoActual = 60;

  custom_response.Response result = custom_response.Response(success: false);
  final Map<int, RetoState> _retoStates = {};

  // Cambiado a público
  RetoState getRetoState(int idReto) {
    if (!_retoStates.containsKey(idReto)) {
      _retoStates[idReto] = RetoState(
        duracionRetoActual: duracionRetoActual,
        seriesTotales: seriesTotales,
      );
    }
    return _retoStates[idReto]!;
  }

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

  void startRetoFromView(Reto reto) {
    final retoState = getRetoState(reto.idReto!);
    retoState.reset();
    retoState.startTimer();
  }

  Future<void> completeReto(Reto reto) async {
    isLoading.value = true;
    final retoState = getRetoState(reto.idReto!);

    result = await _supabaseService.usuarios_retos.updateUsuarioReto(UsuarioReto(
      idUsuario: idUsuarioLogged,
      idReto: reto.idReto!,
      completado: true,
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now(),
    ));

    if (result.success) {
      retoState.dispose();
      _retoStates.remove(reto.idReto);
      Get.back();
      Get.snackbar("Éxito", "Reto completado");
      await getRetosOfUser();
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    for (var state in _retoStates.values) {
      state.dispose();
    }
    _retoStates.clear();
    super.onClose();
  }
}