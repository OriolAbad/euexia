import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/trainings/controller/sing_training_controller.dart';

class SingTrainingView extends StatelessWidget {
  final int trainingId;

  const SingTrainingView({super.key, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    final SingTrainingController trainingsController = Get.put(SingTrainingController(trainingId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back(); // Vuelve a la página anterior
          },
        ),
        title: Obx(() {
          if (trainingsController.isLoading.value) {
            return const Text(
              "Loading...",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainingsController.selectedRutina.value.nombre.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trainingsController.selectedRutina.value.descripcion != null)
                  Text(
                    trainingsController.selectedRutina.value.descripcion!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          }
        }),
      ),
      body: Obx(() {
        if (trainingsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  showAddExerciseModal(context, trainingsController); // Llama a la función para mostrar la modal
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Add exercise",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: trainingsController.selectedRutina.value.ejercicios?.length ?? 0,
                  itemBuilder: (context, index) {
                    final ejercicioRutina = trainingsController.selectedRutina.value.ejercicios![index];
                    return GestureDetector(
                      onTap: () {
                        // Evento de clic (de momento no hace nada)
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fitness_center, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ejercicioRutina.ejercicio?.nombre ?? "Unknown Exercise",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${ejercicioRutina.series} sets, ${ejercicioRutina.repeticiones} reps, ${ejercicioRutina.kilogramos ?? 0} kg",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  // Función para mostrar la modal
  void showAddExerciseModal(BuildContext context, SingTrainingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Fondo negro/gris
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Agregar Ejercicio",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Texto blanco
                    backgroundColor: Colors.blue, // Botón azul
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    
                  },
                  child: const Text('Agregar Ejercicio'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra la modal
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Texto blanco
                backgroundColor: Colors.grey[700], // Botón gris
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}