import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'package:euexia/app/data/models/retos.dart';

class PomodoroChallengeView extends StatefulWidget {
  final Reto reto;

  PomodoroChallengeView({required this.reto});

  @override
  State<PomodoroChallengeView> createState() => _PomodoroChallengeViewState();
}

class _PomodoroChallengeViewState extends State<PomodoroChallengeView> {
  final ChallengesController challengesController = Get.find<ChallengesController>();

  @override
  void dispose() {
    challengesController.resetPomodoro();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.reto.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Obx(() {
          final isTimerRunning = challengesController.isTimerRunning.value;
          final currentTime = challengesController.currentTime.value;
          final isRetoCompleted = challengesController.isRetoCompleted.value;
          final seriesCompletadas = challengesController.seriesCompletadas.value;
          final seriesTotales = challengesController.seriesTotales;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Serie: $seriesCompletadas/$seriesTotales",
                style: const TextStyle(color: Colors.white70, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                isRetoCompleted
                    ? "¡Reto completado!"
                    : _formatTime(currentTime),
                style: TextStyle(
                  color: isRetoCompleted ? Colors.greenAccent : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              if (!challengesController.isTimerInitialized.value) ...[
                ElevatedButton(
                  onPressed: () {
                    challengesController.startRetoFromView(widget.reto);
                  },
                  child: const Text("Iniciar reto"),
                ),
              ] else if (isRetoCompleted && seriesCompletadas < seriesTotales) ...[
                ElevatedButton(
                  onPressed: () {
                    challengesController.nextSerie();
                  },
                  child: const Text("Siguiente descanso"),
                )
              ] else if (isRetoCompleted && seriesCompletadas >= seriesTotales) ...[
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("🎉 ¡Felicidades, completaste el reto!"),
                )
              ] else ...[
                Row(
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
                          challengesController.pauseTimer();
                        } else {
                          challengesController.resumeTimer();
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        challengesController.completeReto();
                      },
                      child: const Text("Finalizar reto"),
                    ),
                  ],
                )
              ],
            ],
          );
        }),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
