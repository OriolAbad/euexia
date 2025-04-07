import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_routines_controller.dart';
import 'package:euexia/app/modules/user_routines/views/routine_exercicese_view.dart';

class UserRoutinesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRoutinesController controller = Get.put(UserRoutinesController());

    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "User Routines",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back(); // Vuelve a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.rutinas.isEmpty) {
            return const Center(
              child: Text(
                "No routines found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.rutinas.length,
            itemBuilder: (context, index) {
              final rutina = controller.rutinas[index];
              return GestureDetector(
                onTap: () {
                  // Navegar a la vista de ejercicios de la rutina
                  Get.to(() => RoutineExercisesView(rutina: rutina));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rutina.nombre, // Accede directamente a la propiedad
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rutina.descripcion ?? 'Sin descripción',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ejercicios: ${rutina.ejercicios?.length ?? 0}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}