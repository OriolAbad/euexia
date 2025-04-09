import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:euexia/app/modules/trainings/controller/start_training_controller.dart';

class StartTrainingView extends StatefulWidget {
  final Rutina rutina;

  const StartTrainingView({super.key, required this.rutina});

  @override
  _StartTrainingViewState createState() => _StartTrainingViewState();
}

class _StartTrainingViewState extends State<StartTrainingView> {
  late final StartTrainingController controller;
  bool isResting = false; // Indica si estamos en tiempo de descanso

  @override
  void initState() {
    super.initState();
    controller = Get.put(StartTrainingController(widget.rutina));
    controller.startCountdown(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Start Training: ${widget.rutina.nombre}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Obx(() {
            final minutes = (controller.elapsedTime.value ~/ 60).toString().padLeft(2, '0');
            final seconds = (controller.elapsedTime.value % 60).toString().padLeft(2, '0');
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '$minutes:$seconds',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.countdown.value > 0 && isResting) {
          // Mostrar el contador de descanso
          return Center(
            child: Text(
              'Descanso: ${controller.countdown.value}s',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          final ejercicios = controller.ejerciciosRutina;
          final totalEjercicios = ejercicios.length;

          if (totalEjercicios == 0) {
            return const Center(
              child: Text(
                "No hay ejercicios en esta rutina.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          final ejercicioActual = ejercicios[controller.currentExerciseIndex.value];

          return Column(
            children: [
              // Stepper/Progress Steps
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejercicio ${controller.currentExerciseIndex.value + 1} de $totalEjercicios',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (controller.currentExerciseIndex.value + 1) / totalEjercicios,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),
              // Mostrar el ejercicio actual
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ejercicioActual.ejercicio?.nombre ?? "Unknown Exercise",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Series totales: ${ejercicioActual.series}", // Mostrar las series originales del ejercicio
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          [
                            if (ejercicioActual.repeticiones > 0)
                              "Reps: ${ejercicioActual.repeticiones}",
                            if (ejercicioActual.kilogramos != null &&
                                ejercicioActual.kilogramos! > 0)
                              "Kg: ${ejercicioActual.kilogramos}",
                          ].join(", "),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Mostrar las series restantes en un texto aparte
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Obx(() {
                  return Text(
                    "Series restantes: ${controller.seriesSelectedExercise.value}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
              // Botón para completar la serie
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Mostrar selector de tiempo de descanso
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Selecciona el tiempo de descanso",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [15, 30, 60].map((time) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Cerrar el modal
                                      setState(() {
                                        isResting = true;
                                      });
                                      controller.reduceSeriesAndRest(
                                        time,
                                        () {
                                          setState(() {
                                            isResting = false;
                                          });
                                        },
                                        () {
                                          // Mostrar el modal de descanso al finalizar el ejercicio
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.black,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      "Selecciona el tiempo de descanso",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [15, 30, 60].map((time) {
                                                        return ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.blue,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop(); // Cerrar el modal
                                                            setState(() {
                                                              isResting = true;
                                                            });
                                                            controller.reduceSeriesAndRest(
                                                              time,
                                                              () {
                                                                setState(() {
                                                                  isResting = false;
                                                                });
                                                              },
                                                              () {
                                                                Get.snackbar(
                                                                  "Entrenamiento finalizado",
                                                                  "¡Buen trabajo!",
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            "$time s",
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "$time s",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Obx(() {
                    return Text(
                      controller.seriesSelectedExercise.value == 1
                          ? "Finalizar Ejercicio"
                          : "Completar Serie",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}