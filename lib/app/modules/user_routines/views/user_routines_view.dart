import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_routines_controller.dart';

class UserRoutinesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtén el argumento (id del usuario) pasado a esta vista
    final UserRoutinesController controller = Get.put(UserRoutinesController());
    final int userId = Get.arguments;

    // Llama a la función para obtener las rutinas del usuario
    controller.getRutinasOfUserWithExercises(userId);

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
              return Container(
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.fitness_center, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rutina['nombre'] ?? 'Sin nombre',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Exercises: ${rutina['ejercicios']?.length ?? 0}",
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
              );
            },
          );
        }),
      ),
    );
  }
}
