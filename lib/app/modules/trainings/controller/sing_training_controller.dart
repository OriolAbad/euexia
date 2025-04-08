import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingTrainingController extends GetxController {
  final Rx<Rutina> rutina;
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var updating = false.obs;
  var adding = false.obs;

  var ejercicioRutina = EjercicioRutina(
    idRutina: 0,
    idEjercicio: 0,
    series: 0,
    repeticiones: 0,
  ).obs;

  SingTrainingController(Rutina rutina) : rutina = rutina.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    ejercicioRutina.value.idRutina = rutina.value.idRutina!;
  }

  Future<void> addEjercicioToRutina() async {
    isLoading.value = true;
    final nuevoEjercicio = ejercicioRutina.value;
    result = await _supabaseService.ejercicios_rutinas.addEjercicioRutina(ejercicioRutina.value);

    if (!result.success) {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    } else {
      rutina.value.ejercicios!.add(nuevoEjercicio);
    }
    isLoading.value = false;
  }

  Future<void> updateEjercicio() async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios_rutinas.updateEjercicioRutina(ejercicioRutina.value);

    if (!result.success) {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    }
    isLoading.value = false;
  }

  Future<void> deleteEjercicioRutina(EjercicioRutina ejercicio) async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios_rutinas.deleteEjercicioRutina(ejercicio.idRutina, ejercicio.idEjercicio);

    if (!result.success) {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    } else {
      rutina.value.ejercicios!.remove(ejercicio);
    }
    isLoading.value = false;
  }

  void resetEjercicioRutina() {
    updating.value = false;
    adding.value = false;
    ejercicioRutina = EjercicioRutina(
      idRutina: rutina.value.idRutina ?? 0,
      idEjercicio: 0,
      series: 0,
      repeticiones: 0,
    ).obs;
  }
}