import 'package:euexia/app/data/models/rutinas.dart';
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
              showModalNewRutina(context, trainingsController);
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
                      Get.to(
                        () => SingTrainingView(),
                        arguments: {'rutina': rutina}, // Pasa la rutina completa como argumento
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Color azul
                        borderRadius: BorderRadius.circular(12), // Bordes redondos
                      ),
                      child: Row(
                        children: [
                          // Información de la rutina
                          Expanded(
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
                                if (rutina.descripcion != null && rutina.descripcion!.isNotEmpty)
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
                          const SizedBox(width: 16),
                          // Botón de papelera
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDeleteModal(context, trainingsController, rutina);
                            },
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

  void showModalNewRutina(BuildContext context, TrainingsController trainingsController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nueva Rutina",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Campo de texto para el nombre de la rutina
              TextField(
                onChanged: (value) {
                  trainingsController.rutina.value.nombre = value; // Accede a través de .value
                },
                decoration: InputDecoration(
                  labelText: "Nombre de la rutina",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Campo de texto para la descripción de la rutina
              TextField(
                onChanged: (value) {
                  trainingsController.rutina.value.descripcion = value; // Accede a través de .value
                },
                decoration: InputDecoration(
                  labelText: "Descripción de la rutina",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Toggle switch para "publicada"
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "¿Publicar rutina?",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Switch(
                      value: trainingsController.usuarioRutina.value.publicada ?? false,
                      onChanged: (value) {
                        trainingsController.usuarioRutina.value.publicada = value;
                        trainingsController.usuarioRutina.refresh(); // Refresca el observable
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await trainingsController.addRutina();
                    Navigator.of(context).pop(); // Cierra la modal después de guardar
                  },
                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteModal(BuildContext context, TrainingsController trainingsController, Rutina rutina) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "¿Desea eliminar esta rutina?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                rutina.nombre, // Aquí no necesitas .value porque rutina no es Rx
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        await trainingsController.deleteRutina(rutina);
                        Navigator.of(context).pop(); // Cierra la modal después de eliminar
                      },
                      child: const Text(
                        "Eliminar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra la modal sin hacer nada
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}