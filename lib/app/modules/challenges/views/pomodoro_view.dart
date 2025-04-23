// views/pomodoro_challenge_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'package:euexia/app/data/models/retos.dart';

class PomodoroChallengeView extends StatelessWidget {
  final Reto reto;

  PomodoroChallengeView({required this.reto});

  final ChallengesController challengesController = Get.find<ChallengesController>();

  @override
  Widget build(BuildContext context) {
    // Duración del temporizador en segundos (por ejemplo, 25 minutos)
    final int durationInSeconds = 1500; // 25 minutos = 1500 segundos

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(reto.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Obx(() {
          final isTimerRunning = challengesController.isTimerRunning.value;
          final currentTime = challengesController.currentTime.value;
          final isRetoCompleted = challengesController.isRetoCompleted.value;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mostramos el tiempo restante o el mensaje de reto completado
              Text(
                isRetoCompleted
                    ? "¡Reto completado!"
                    : _formatTime(currentTime), // Formateamos el tiempo a minutos:segundos
                style: TextStyle(
                  color: isRetoCompleted ? Colors.greenAccent : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              // Botones de control
              isRetoCompleted
                  ? ElevatedButton(
                      onPressed: () {
                        // Inicia una nueva serie del reto
                        challengesController.nextSerie(durationInSeconds);
                      },
                      child: const Text("Siguiente serie"),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isTimerRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            if (isTimerRunning) {
                              challengesController.pauseTimer(); // Pausa el timer
                            } else {
                              challengesController.resumeTimer(); // Reanuda el timer
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Completa el reto
                            challengesController.completeReto();
                          },
                          child: const Text("Finalizar reto"),
                        ),
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }

  // Función para formatear el tiempo restante en minutos:segundos
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60; // Divide por 60 para obtener los minutos
    int seconds = totalSeconds % 60; // Resto de la división para obtener los segundos
    return "$minutes:${seconds.toString().padLeft(2, '0')}"; // Devuelve el tiempo como "mm:ss"
  }
}
