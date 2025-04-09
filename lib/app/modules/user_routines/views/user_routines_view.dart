import 'package:euexia/app/routes/app_pages.dart';
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
            Get.toNamed(Routes.HOME);
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
                      SaveButton(
                          rutina:
                              rutina), // Botón con animación, if IsSaved true, savedRoutines.Add(rutina)
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.saveAllSavedRoutines(); // Configura tu lógica aquí
        },
        backgroundColor: Colors.blue, // Color del botón
        child: const Icon(Icons.save, color: Colors.white), // Ícono del botón
      ),
    );
  }
}

class SaveButton extends StatefulWidget {
  final dynamic rutina;

  SaveButton({required this.rutina});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isSaved = false;
  late final UserRoutinesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserRoutinesController>();
    isSaved = controller.savedRoutines.contains(widget.rutina);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Da error de ValueKey duplicado, ARREGLARLO
        setState(() {
          isSaved = !isSaved;
        });

        if (isSaved) {
          controller.savedRoutines.add(widget.rutina);
          Get.snackbar(
            'Rutina guardada',
            'Has guardado esta rutina.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          controller.savedRoutines.remove(widget.rutina);
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
            color: isSaved ? Colors.green[100] : Colors.blue[100],
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            isSaved ? Icons.check : Icons.add,
            color: isSaved ? Colors.green : Colors.blue,
          ),
        ),
      ),
    );
  }
}
