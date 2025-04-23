// views/challenges_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'pomodoro_view.dart'; // Importamos la vista de Pomodoro
import 'package:euexia/app/data/models/usuarios_retos.dart';

class ChallengesView extends StatelessWidget {
  ChallengesView({super.key});

  final ChallengesController challengesController = Get.put(ChallengesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("CHALLENGES", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        if (challengesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (challengesController.retos.isEmpty) {
          return const Center(
            child: Text(
              "No hay retos asignados.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: challengesController.retos.length,
          itemBuilder: (context, index) {
            final UsuarioReto usuarioReto = challengesController.retos[index];
            final reto = usuarioReto.reto;

            if (reto == null) {
              return const SizedBox(); // En caso de que el reto no esté cargado
            }

            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.white),
                title: Text(
                  reto.titulo,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  reto.descripcion,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Icon(
                  usuarioReto.completado ? Icons.check_circle : Icons.circle_outlined,
                  color: usuarioReto.completado ? Colors.greenAccent : Colors.white,
                ),
                onTap: () {
                  // Al hacer tap en el reto, navegamos a la vista de Pomodoro
                  Get.to(() => PomodoroChallengeView(reto: reto));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
