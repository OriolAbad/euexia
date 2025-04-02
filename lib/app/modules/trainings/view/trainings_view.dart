import 'package:euexia/app/routes/app_pages.dart';
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
        foregroundColor: Colors.white,
        title: const Text('Trainings'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(Routes.HOME); // Vuelve a la pantalla anterior
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              // Acción del botón '+' (de momento no hace nada)
            },
          ),
        ],
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
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16), // Espacio superior para evitar superposición
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
        ],
      ),
    );
  }
}