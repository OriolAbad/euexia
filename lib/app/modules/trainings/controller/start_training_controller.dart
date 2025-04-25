import 'dart:async';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/dias_entrenados.dart';
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/records_personales.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartTrainingController extends GetxController {
  StartTrainingController(Rutina rutina) : rutina = rutina.obs;

  final Rx<Rutina> rutina;
  int idUsuarioLogged = 0; // ID del usuario logueado
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  var initialTimerBool = true.obs; // Estado del temporizador inicial (cuenta regresiva)
  var isResting = false.obs; // Estado de descanso

  var elapsedTime = 0.obs; // Tiempo transcurrido en segundos
  var restTime = 0.obs; // Tiempo de descanso en segundos
  Timer? timer; // Timer para el contador

  var currentSerie = 1.obs;
  var currenExerciseIndex = 0.obs; // Índice del ejercicio actual
  var currenExercise = Rx<EjercicioRutina?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    initialTimer(); // Llama a la cuenta regresiva al iniciar
    getLoggedUser(); // Obtiene el usuario logueado

    currenExercise.value = rutina.value.ejercicios?[currenExerciseIndex.value]; // Inicializa el primer ejercicio si no es null
  }

  void initialTimer() {
    elapsedTime.value = 3; // Inicia la cuenta regresiva desde 3
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedTime.value > 0) {
        elapsedTime.value--; // Decrementa el tiempo
      } else {
        timer.cancel(); // Detiene el temporizador cuando llega a 0
        initialTimerBool.value = false; // Cambia el estado para mostrar el temporizador principal
        startMainTimer(); // Inicia el temporizador principal
      }
    });
  }

  Future<void> getLoggedUser() async{
    isLoading.value = true;
    result = await _supabaseService.usuarios.getLoggedInUser();

    if(result.success){
      Usuario loggedUser = result.data as Usuario;
      idUsuarioLogged = loggedUser.idUsuario!;
    }
    else{
       Get.snackbar(
      "Error", 
      result.errorMessage ?? "Unknown error",
      backgroundColor: Colors.red, // Fondo rojo
      colorText: Colors.white, // Texto blanco
      duration: const Duration(seconds: 6), // Duración de 6 segundos
    );
    }

    isLoading.value = false;  
  }

  void startMainTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value++; // Incrementa el tiempo transcurrido
    });
  }

  void stopMainTimer() {
    timer?.cancel(); // Detiene el temporizador principal
  }

  void startRestTimer(int seconds) {
    isResting.value = true; // Cambia el estado a descanso

    restTime.value = seconds; // Establece el tiempo de descanso
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (restTime.value > 0) {
        restTime.value--; // Decrementa el tiempo de descanso
      } else {
        timer.cancel();
        restTime.value = 0; 
        isResting.value = false;// Detiene el temporizador de descanso cuando llega a 0
        nextSerie(); // Cambia a la siguiente serie
      }
    });
  }

  void nextSerie(){
    if (currentSerie < currenExercise.value!.series) {
      currentSerie++; // Incrementa la serie actual
    } else {
      currentSerie.value = 1; 
      currenExerciseIndex.value++; // Cambia al siguiente ejercicio
      if (currenExerciseIndex.value < rutina.value.ejercicios!.length) {
        currenExercise.value = rutina.value.ejercicios?[currenExerciseIndex.value]; // Inicializa el primer ejercicio si no es null// Reinicia el índice si se ha llegado al final de la lista
      } else {
        finalizarEntrenamiento(); // Finaliza el entrenamiento si se ha llegado al final de la lista
      }
    } 
  }

  Future<void> finalizarEntrenamiento() async {
    DiaEntrenado newDiaEntrenado = DiaEntrenado(
      idRutina: rutina.value.idRutina ?? 0,
      fechaEntrenamiento: DateTime.now(),
      tiempoEntrenamiento: Duration(seconds: elapsedTime.value),
      idUsuario: idUsuarioLogged // Obtiene el ID del usuario actual
    );

    result = await _supabaseService.dias_entrenados.addTrainedDay(newDiaEntrenado);

    if (result.success) {
      await insertarStats(); // Inserta los stats al finalizar el entrenamiento
      Get.back(); // Regresa a la pantalla anterior
    } else {
       Get.snackbar(
      "Error", 
      result.errorMessage ?? "Unknown error",
      backgroundColor: Colors.red, // Fondo rojo
      colorText: Colors.white, // Texto blanco
      duration: const Duration(seconds: 6), // Duración de 6 segundos
    );
    }
  }

  Future<void> insertarStats() async{
    result = await _supabaseService.records_personales.getRecordsPersonalesByUserId(idUsuarioLogged);

    if(result.success){
      List<RecordPersonal> records = result.data as List<RecordPersonal>;

      if (rutina.value.ejercicios != null) {
        for (var ejercicio_rutina in rutina.value.ejercicios!) {

          if (records.any((r) => r.idEjercicio == ejercicio_rutina.idEjercicio && r.idUsuario == idUsuarioLogged)) {
            var record = records.firstWhere((r) => r.idEjercicio == ejercicio_rutina.idEjercicio && r.idUsuario == idUsuarioLogged);

            if (ejercicio_rutina.kilogramos! > record.record) {
              record.record = ejercicio_rutina.kilogramos!; // Actualiza el record existente
              result = await _supabaseService.records_personales.updateRecordPersonal(record);
              if(!result.success){
                Get.snackbar(
                  "Error", 
                  result.errorMessage ?? "Unknown error",
                  backgroundColor: Colors.red, // Fondo rojo
                  colorText: Colors.white, // Texto blanco
                  duration: const Duration(seconds: 6), // Duración de 6 segundos
                );
              }
            }
          }
          else{
            var newRecord = RecordPersonal(
              idEjercicio: ejercicio_rutina.idEjercicio,
              idUsuario: idUsuarioLogged,
              record: ejercicio_rutina.kilogramos!,
            );
            result = await _supabaseService.records_personales.addRecordPersonal(newRecord);
            if(!result.success){
              Get.snackbar(
                "Error", 
                result.errorMessage ?? "Unknown error",
                backgroundColor: Colors.red, // Fondo rojo
                colorText: Colors.white, // Texto blanco
                duration: const Duration(seconds: 6), // Duración de 6 segundos
              );
            }
          }

          
        }
      }
    }
    else{
      Get.snackbar(
        "Error", 
        result.errorMessage ?? "Unknown error",
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
        duration: const Duration(seconds: 6), // Duración de 6 segundos
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel(); // Cancela el temporizador al cerrar el controlador
    super.onClose();
  }
}