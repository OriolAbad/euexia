import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/data/models/ejercicios_rutinas.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/modules/trainings/view/start_training_view.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/trainings/controller/sing_training_controller.dart';

class SingTrainingView extends StatelessWidget {

  const SingTrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén la rutina desde los argumentos
    final Rutina rutina = Get.arguments['rutina'];
    final SingTrainingController trainingsController = Get.put(SingTrainingController(rutina));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
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
                  trainingsController.rutina.value.nombre.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trainingsController.rutina.value.descripcion != null)
                  Text(
                    trainingsController.rutina.value.descripcion!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          }
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showModalEditRutina(context, trainingsController);
            },
            tooltip: "Editar rutina",
          ),
        ],
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
                onTap: () async {
                  trainingsController.adding.value = true; // Cambia el estado a "agregando"
                  // Navega a ExercisesView y espera el resultado
                  final selectedExercise = await Get.toNamed(
                    Routes.EJERCICIOS,
                    arguments: {'trainingId': rutina.idRutina}, // Pasa el trainingId como argumento
                  );
                  // Maneja el objeto ejercicio seleccionado
                  if (selectedExercise != null && selectedExercise is Ejercicio) {
                    // Actualiza el ejercicio seleccionado en el controlador
                    trainingsController.ejercicioRutina.value.idEjercicio = selectedExercise.idEjercicio!;
                    trainingsController.ejercicioRutina.value.ejercicio = selectedExercise;
                    showModalNewExercise(context, trainingsController);
                  }
},
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFD32F2F),
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
                  itemCount: trainingsController.rutina.value.ejercicios?.length ?? 0,
                  itemBuilder: (context, index) {
                    final ejercicioRutina = trainingsController.rutina.value.ejercicios![index];
                    return GestureDetector(
                      onTap: () {
                        trainingsController.ejercicioRutina.value = ejercicioRutina;
                        trainingsController.updating.value = true;
                        showModalNewExercise(context, trainingsController);
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
                                color: Color(0xFFD32F2F),
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
                                    "Series: ${ejercicioRutina.series}, Reps: ${ejercicioRutina.repeticiones}, Kilogramos: ${ejercicioRutina.kilogramos ?? 0}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
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
                                showDeleteModal(context, trainingsController, ejercicioRutina);
                              },
                              tooltip: "Eliminar ejercicio",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F), // Color del botón
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.to(
                        () => StartTrainingView(),
                        arguments: {'rutina': rutina}, // Pasa la rutina completa como argumento
                      );
                  },
                  child: const Center(
                    child: Text(
                      "START TRAINING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

void showModalNewExercise(BuildContext context, SingTrainingController trainingsController) {
  if(trainingsController.adding.value) {
    trainingsController.ejercicioRutina.value.kilogramos = null;
    trainingsController.ejercicioRutina.value.series = 0;
    trainingsController.ejercicioRutina.value.repeticiones = 0;
  }
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
            // Botón de cerrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Editar Ejercicio",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    trainingsController.resetEjercicioRutina();// Cambia el estado a "no agregando"
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Textbox para mostrar el nombre del ejercicio seleccionado
            Obx(() {
              return TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Ejercicio",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(
                  text: trainingsController.ejercicioRutina.value.ejercicio?.nombre ?? "Selecciona un ejercicio",
                ),
              );
            }),
            const SizedBox(height: 16),
            // NumberInput para series
             Obx(() {
              return TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  trainingsController.ejercicioRutina.value.series = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: "Series",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(
                  text: trainingsController.ejercicioRutina.value.series > 0
                      ? trainingsController.ejercicioRutina.value.series.toString()
                      : '',
                ),
              );
            }),
            const SizedBox(height: 16),
            // NumberInput para repeticiones
             Obx(() {
              return TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  trainingsController.ejercicioRutina.value.repeticiones = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: "Repeticiones",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(
                  text: trainingsController.ejercicioRutina.value.repeticiones > 0
                      ? trainingsController.ejercicioRutina.value.repeticiones.toString()
                      : '',
                ),
              );
            }),
            const SizedBox(height: 16),
            // NumberInput para kilogramos
            Obx(() {
              return TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  trainingsController.ejercicioRutina.value.kilogramos = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(
                  labelText: "Kilogramos",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(
                  text: trainingsController.ejercicioRutina.value.kilogramos?.toString() ?? '',
                ),
              );
            }),
            const SizedBox(height: 24),
            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (trainingsController.updating.value) {
                    trainingsController.updateEjercicio();
                    trainingsController.resetEjercicioRutina();
                  } else if (trainingsController.adding.value) {
                    trainingsController.addEjercicioToRutina();
                    trainingsController.resetEjercicioRutina(); // Cambia el estado a "no actualizando"
                  }
                  Navigator.of(context).pop();
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

void showDeleteModal(BuildContext context, SingTrainingController trainingsController, EjercicioRutina ejercicioRutina) {
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
            // Texto de confirmación
            const Text(
              "¿Desea eliminar este ejercicio?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ejercicioRutina.ejercicio?.nombre ?? "Nombre desconocido",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de eliminar
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
                      await trainingsController.deleteEjercicioRutina(ejercicioRutina);
                      Navigator.of(context).pop(); // Cierra la modal después de eliminar
                    },
                    child: const Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Botón de cancelar
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

void showModalEditRutina(BuildContext context, SingTrainingController trainingsController) {
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
              "Edit Rutina",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Campo de texto para el nombre de la rutina
            Obx(() {
              return TextField(
                onChanged: (value) {
                  trainingsController.rutina.value.nombre = value; // Actualiza el nombre
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
                controller: TextEditingController(
                  text: trainingsController.rutina.value.nombre,
                )..selection = TextSelection.fromPosition(
                    TextPosition(offset: trainingsController.rutina.value.nombre.length),
                  ),
              );
            }),
            const SizedBox(height: 16),
            // Campo de texto para la descripción de la rutina
            Obx(() {
              return TextField(
                onChanged: (value) {
                  trainingsController.rutina.value.descripcion = value; // Actualiza la descripción
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
                controller: TextEditingController(
                  text: trainingsController.rutina.value.descripcion ?? '',
                )..selection = TextSelection.fromPosition(
                    TextPosition(offset: trainingsController.rutina.value.descripcion?.length ?? 0),
                  ),
              );
            }),
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
                    value: trainingsController.usuarioRutina.value.publicada,
                    onChanged: (value) {
                      trainingsController.usuarioRutina.value.publicada = value;
                      trainingsController.usuarioRutina.refresh(); // Refresca el observable
                    },
                    activeColor: Color(0xFFD32F2F),
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
                  backgroundColor: Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await trainingsController.editRutina();
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

