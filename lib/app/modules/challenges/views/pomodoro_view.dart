import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'package:euexia/app/data/models/retos.dart';

class PomodoroChallengeView extends StatefulWidget {
  final Reto reto;

  const PomodoroChallengeView({Key? key, required this.reto}) : super(key: key);

  @override
  State<PomodoroChallengeView> createState() => _PomodoroChallengeViewState();
}

class _PomodoroChallengeViewState extends State<PomodoroChallengeView> {
  final ChallengesController challengesController = Get.find<ChallengesController>();
  late final RetoState retoState;
  bool showStartButton = true;

  @override
  void initState() {
    super.initState();
    retoState = challengesController.getRetoState(widget.reto.idReto!);
    showStartButton = !retoState.isTimerRunning.value && retoState.seriesCompletadas.value == 0;
  }

  @override
  void dispose() {
    retoState.reset();
    super.dispose();
  }

  double get currentSerieProgress {
    return 1 - (retoState.currentTime.value / challengesController.duracionRetoActual);
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contador de tiempo principal
              Text(
                retoState.isRetoCompleted.value
                    ? "¡Descanso terminado!"
                    : _formatTime(retoState.currentTime.value),
                style: TextStyle(
                  color: retoState.isRetoCompleted.value ? Colors.greenAccent : Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Indicador de serie actual (Modificado)
              Text(
                retoState.seriesCompletadas.value >= challengesController.seriesTotales
                    ? "¡Reto completado!"
                    : "Serie ${retoState.seriesCompletadas.value + 1} de ${challengesController.seriesTotales}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Barra de progreso segmentada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(challengesController.seriesTotales, (index) {
                    final serieIndex = index + 1;
                    final isCurrentSerie = serieIndex == retoState.seriesCompletadas.value + 1;
                    final isCompleted = serieIndex <= retoState.seriesCompletadas.value;
                    
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Stack(
                          children: [
                            if (isCompleted)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: double.infinity,
                              ),
                            if (isCurrentSerie && !retoState.isRetoCompleted.value)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent[400],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: isCompleted 
                                    ? double.infinity 
                                    : currentSerieProgress * MediaQuery.of(context).size.width / challengesController.seriesTotales,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botón único (Start/Pause/Next)
              if (showStartButton) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    retoState.startTimer();
                    setState(() => showStartButton = false);
                  },
                  child: const Text("COMENZAR RETO", style: TextStyle(fontSize: 18)),
                )
              ] else if (retoState.isRetoCompleted.value && 
                        retoState.seriesCompletadas.value < challengesController.seriesTotales) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    retoState.nextSerie();
                  },
                  child: const Text("SIGUIENTE SERIE", style: TextStyle(fontSize: 18)),
                )
              ] else if (retoState.seriesCompletadas.value >= challengesController.seriesTotales) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    challengesController.completeReto(widget.reto);
                  },
                  child: const Text("🎉 ¡RETO COMPLETADO!", style: TextStyle(fontSize: 18)),
                )
              ] else ...[
                IconButton(
                  icon: Icon(
                    retoState.isTimerRunning.value ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    color: Colors.white,
                    size: 70,
                  ),
                  onPressed: () {
                    if (retoState.isTimerRunning.value) {
                      retoState.pauseTimer();
                    } else {
                      retoState.resumeTimer();
                    }
                  },
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
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}