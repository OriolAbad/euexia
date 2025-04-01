// lib/views/challenges_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/challenges_controller.dart';
import 'package:euexia/app/modules/home/views/home_view.dart'; 
import 'package:euexia/app/modules/challenges/views/pomodoro_view.dart';

class ChallengesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChallengesController controller = Get.put(ChallengesController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("CHALLENGES", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.off(() => HomeView()); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Puntos
            Obx(() => ElevatedButton(
                  onPressed: () {},
                  child: Text("POINTS ${controller.points}"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                )),
            SizedBox(height: 20),

            // Desafíos completados
            Obx(() => Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "COMPLETED ${controller.completedCount}/${controller.challenges.length}",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: 20),

            // Lista de desafíos
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = controller.challenges[index];

                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          leading: Image.asset(challenge.image, width: 40, height: 40, fit: BoxFit.cover),
                          title: Text(
                            challenge.name,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            challenge.description,
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: challenge.isCompleted
                              ? Icon(Icons.check_circle, color: Colors.purple)
                              : Icon(Icons.circle_outlined, color: Colors.white),
                          onTap: () {
                            Get.to(() => PomodoroView(
                              series: 1, // Ajusta según el desafío
                              descanso: 60, // Ajusta según el desafío
                            ))?.then((result) { // Usa ? para evitar el error si Get.to() devuelve null
                              if (result == true) { 
                                controller.challenges[index].isCompleted = true;
                                controller.challenges.refresh();
                              }
                            });
                          },

                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
