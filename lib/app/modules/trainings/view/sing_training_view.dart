import 'package:euexia/app/modules/trainings/controller/sing_training_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingTrainingView extends StatelessWidget {
  final int trainingId; // Parámetro recibido

  SingTrainingView({super.key, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador con el trainingId
    final SingTrainingController trainingsController = Get.put(SingTrainingController(trainingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Details'),
      ),
      body: Obx(() {
        if (trainingsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('Training details loaded successfully!'),
          );
        }
      }),
    );
  }
}