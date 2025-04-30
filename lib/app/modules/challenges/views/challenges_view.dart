import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'pomodoro_view.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';

class ChallengesView extends StatelessWidget {
  ChallengesView({Key? key}) : super(key: key);

  final ChallengesController challengesController = Get.put(ChallengesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Retos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>  Get.offNamed(Routes.HOME), // Vuelve al home
        ),
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

            if (reto == null) return const SizedBox();

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
                  if (!usuarioReto.completado) {
                    Get.to(() => PomodoroChallengeView(reto: reto));
                  } else {
                    Get.snackbar("Info", "¡Ya completaste este reto!");
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}