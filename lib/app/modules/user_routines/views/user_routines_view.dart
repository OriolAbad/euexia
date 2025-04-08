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
            controller.saveAllSavedRoutines(); // Guarda las rutinas que esten en isSaved == true al salir
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rutina
                                  .nombre, // Accede directamente a la propiedad
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
                      SaveButton(), // Botón con animación, if IsSaved true, savedRoutines.Add(rutina)
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

class SaveButton extends StatefulWidget {
  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSaved = !isSaved; // Cambia el estado entre guardado y no guardado
        });

        // Lógica adicional para guardar la rutina
        if (isSaved) {
          Get.snackbar(
            'Rutina guardada',
            'Has guardado esta rutina.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Rutina eliminada',
            'Has eliminado esta rutina de tus guardadas.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Container(
          key: ValueKey(isSaved),
          decoration: BoxDecoration(
            color: isSaved
                ? Colors.green[100]
                : Colors.blue[100], // Fondo dinámico
            shape: BoxShape.circle, // Forma circular
          ),
          padding: const EdgeInsets.all(8.0), // Espaciado interno
          child: Icon(
            isSaved ? Icons.check : Icons.add,
            color: isSaved ? Colors.green : Colors.blue, // Color del ícono
          ),
        ),
      ),
    );
  }
}
