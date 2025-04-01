// lib/controllers/challenges_controller.dart
import 'package:get/get.dart';

class Challenge {
  String name;
  String description;
  String image;
  bool isCompleted;

  Challenge({
    required this.name,
    required this.description,
    required this.image,
    this.isCompleted = false, // Valor manual por ahora
  });
}

class ChallengesController extends GetxController {
  var points = 100.obs; 
  var challenges = <Challenge>[
    Challenge(name: "Curl martillo", description: "3 sets, 8-12 reps", image: "assets/curl_martillo.png", isCompleted: false),
    Challenge(name: "Curl inclinado", description: "3 sets, 8-12 reps", image: "assets/curl_inclinado.png", isCompleted: false),
    Challenge(name: "Curl predicador", description: "3 sets, 8-12 reps", image: "assets/curl_predicador.png", isCompleted: false),
    Challenge(name: "Extensión de tríceps", description: "3 sets, 8-12 reps", image: "assets/extension_triceps.png", isCompleted: false),
    Challenge(name: "Extensión de tríceps tras nuca", description: "3 sets, 8-12 reps", image: "assets/extension_nuca.png", isCompleted: false),
    Challenge(name: "Fondos en máquina", description: "3 sets, 8-12 reps", image: "assets/fondos_maquina.png", isCompleted: false),
  ].obs;

  int get completedCount => challenges.where((c) => c.isCompleted).length;
}
