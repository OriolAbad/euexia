import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/trainings/controller/trainings_controller.dart';
import 'package:euexia/app/modules/trainings/view/sing_training_view.dart';

class TrainingsView extends StatelessWidget {
  TrainingsView({super.key});

  final TrainingsController trainingsController = Get.find<TrainingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: const Text('Trainings'),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (trainingsController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16), // Espacio superior para evitar superposición
                itemCount: trainingsController.trainings.length,
                itemBuilder: (context, index) {
                  final rutina = trainingsController.trainings[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SingTrainingView(trainingId: rutina.idRutina!));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Color azul
                        borderRadius: BorderRadius.circular(12), // Bordes redondos
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rutina.nombre.toUpperCase(), // Nombre en mayúsculas
                            style: const TextStyle(
                              color: Colors.white, // Letras blancas
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (rutina.descripcion != null &&
                              rutina.descripcion!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                rutina.descripcion!,
                                style: const TextStyle(
                                  color: Colors.white, // Letras blancas
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Botón de agregar rutina (de momento no hace nada)
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}