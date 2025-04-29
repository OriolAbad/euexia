import 'package:flutter/material.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/modules/trainings/controller/start_training_controller.dart';
import 'package:get/get.dart';

class StartTrainingView extends StatelessWidget {
  StartTrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    final Rutina rutina = Get.arguments['rutina'];
    final StartTrainingController trainingsController = Get.put(StartTrainingController(rutina));

    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo negro
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Cambia el color de la flecha a blanco
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rutina.nombre.toUpperCase(), // Nombre de la rutina en grande
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (rutina.descripcion != null)
              Text(
                rutina.descripcion!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          Obx(() {
            if (!trainingsController.initialTimerBool.value) {
              // Muestra el timer HH:MM:SS después de la cuenta regresiva
              final int elapsedSeconds = trainingsController.elapsedTime.value;
              final String hours = (elapsedSeconds ~/ 3600).toString().padLeft(2, '0'); // Horas
              final String minutes = ((elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0'); // Minutos
              final String seconds = (elapsedSeconds % 60).toString().padLeft(2, '0'); // Segundos
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    '$hours:$minutes:$seconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink(); // No muestra nada durante la cuenta regresiva
          }),
        ],
      ),
      body: Obx(() {
        if (trainingsController.initialTimerBool.value) {
          // Mostrar la cuenta regresiva si initialTimerBool es true
          return Center(
            child: Text(
              '${trainingsController.elapsedTime.value}', // Muestra el tiempo restante
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } 
        else if (trainingsController.isResting.value) {
          // Mostrar el tiempo de descanso en formato MM:SS
          final int minutes = trainingsController.restTime.value ~/ 60; // Minutos
          final int seconds = trainingsController.restTime.value % 60; // Segundos

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "RESTING TIME:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}", // Formato MM:SS
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        else {
          // Mostrar el ejercicio actual y la serie actual
          final currentExercise = trainingsController.currenExercise.value;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rectángulo gris con la información del ejercicio
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Fondo gris
                    borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentExercise?.ejercicio?.nombre ?? "NOMBRE EJERCICIO",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Series: ${currentExercise?.series ?? 0}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kilogramos: ${currentExercise?.kilogramos ?? 0}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Texto de la serie actual
                Text(
                  "SERIE: ${trainingsController.currentSerie.value}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Botón "Siguiente Entrenamiento"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F), // Botón azul
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    ),
                  ),
                  onPressed: () {
                    showRestModal(context, trainingsController); // Cambia a la siguiente serie
                  },
                  child: Obx(() {
                    // Cambia el texto dinámicamente según la condición
                    return Text(
                      trainingsController.currentSerie.value < (trainingsController.currenExercise.value?.series ?? 0)
                          ? "SIGUIENTE SERIE"
                          : "SIGUIENTE EJERCICIO",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

void showRestModal(BuildContext context, StartTrainingController controller) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      // Inicializa los valores seleccionados como observables
      var selectedMinutes = 0.obs;
      var selectedSeconds = 0.obs;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Selecciona el tiempo de descanso",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dropdown para seleccionar minutos
                Obx(() {
                  return DropdownButton<int>(
                    dropdownColor: Colors.grey[900],
                    value: selectedMinutes.value, // Valor actual o predeterminado
                    items: List.generate(10, (index) => index)
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                "$e min",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedMinutes.value = value ?? 0; // Si es null, asigna 0
                    },
                  );
                }),
                const SizedBox(width: 16),
                // Dropdown para seleccionar segundos
                Obx(() {
                  return DropdownButton<int>(
                    dropdownColor: Colors.grey[900],
                    value: selectedSeconds.value, // Valor actual o predeterminado
                    items: List.generate(60, (index) => index)
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                "$e sec",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedSeconds.value = value ?? 0; // Si es null, asigna 0
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD32F2F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Cierra el modal
                int totalSeconds = (selectedMinutes.value * 60) + selectedSeconds.value;
                controller.startRestTimer(totalSeconds); // Llama a la función del controlador
              },
              child: const Text(
                "SELECCIONAR",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    },
  );
}