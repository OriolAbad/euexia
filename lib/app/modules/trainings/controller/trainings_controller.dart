import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_rutinas.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingsController extends GetxController{
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;

  late int numberOfTrainings;
  var trainings = [].obs;
  late Usuario usuario;

  var rutina = Rutina(
    idRutina: 0, // Default value
    nombre: "",
    descripcion: "",
    ejercicios: [],
  ).obs;

  var usuarioRutina = UsuarioRutina(
    idUsuario: 0,
    idRutina: 0,
  ).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLoggedInUser();
    await getRutinas();
    await getNumberOfRutinas();
    usuarioRutina.value.idUsuario = usuario.idUsuario!;
  }

  Future<void> getLoggedInUser() async {
    result = await _supabaseService.usuarios.getLoggedInUser();

    if(result.success){
      usuario = result.data as Usuario;
    }
    else{
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    }
  }

  Future<void> getRutinas() async {
    isLoading.value = true;
    result = await _supabaseService.usuarios_rutinas.getRutinasOfUserWithExercises(usuario.idUsuario!);
    if(result.success){
      trainings.assignAll(result.data as Iterable); // Asignar correctamente los datos a la lista observable
    }
    else{
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
  
  Future<void> getNumberOfRutinas() async {
    isLoading.value = true;
    result = await _supabaseService.rutinas.getNumberOfRutinas();
    
    if(result.success){
      numberOfTrainings = result.data as int; // Asignar correctamente los datos a la lista observable
    }
    else{
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

  Future<void> addRutina() async {
    isLoading.value = true;
    rutina.value.idRutina = numberOfTrainings + 1; // Incrementar el ID de rutina
    result = await _supabaseService.rutinas.addRutina(rutina.value);
    
    if(result.success){
      trainings.add(rutina.value);
      numberOfTrainings++; // Asignar correctamente los datos a la lista observable
      usuarioRutina.value.idRutina = rutina.value.idRutina!;

      result = await _supabaseService.usuarios_rutinas.addUsuarioRutina(usuarioRutina.value);
      if(!result.success){
        Get.snackbar(
          "Error",
          result.errorMessage ?? "Unknown error",
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red, // Fondo rojo
          colorText: Colors.white, // Texto blanco
        );
      } 
    }
    else{
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

  Future<void> deleteRutina(Rutina rutina) async{
    isLoading.value = true;
    result = await _supabaseService.usuarios_rutinas.deleteUsuarioRutina(usuario.idUsuario!, rutina.idRutina!);
    if(result.success){
      trainings.remove(rutina);
      for (var ejercicioRutina in rutina.ejercicios!) {
        result = await _supabaseService.ejercicios_rutinas.deleteEjercicioRutina(ejercicioRutina.idRutina, ejercicioRutina.idEjercicio);
        if(!result.success){
          Get.snackbar("Error", result.errorMessage ?? "Unknown error");
        }
      }// Asignar correctamente los datos a la lista observable
      result = await _supabaseService.rutinas.deleteRutina(rutina.idRutina!);
      if(!result.success){
        Get.snackbar(
          "Error",
          result.errorMessage ?? "Unknown error",
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red, // Fondo rojo
          colorText: Colors.white, // Texto blanco
        );
      }
    }
    else{
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

   void resetRutina() {
    rutina = Rutina(
      idRutina: numberOfTrainings + 1, // Incrementar el ID de rutina
      nombre: "",
      descripcion: "",
      ejercicios: [],
    ).obs;

    usuarioRutina = UsuarioRutina(
      idUsuario: usuario.idUsuario!,
      idRutina: 0,
    ).obs;
  }
}