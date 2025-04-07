import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_routines_controller.dart';

class UserRoutinesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtén el argumento (id del usuario) pasado a esta vista
    final int userId = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Routines'),
      ),
      body: Center(
        child: Text('Mostrando rutinas para el usuario con ID: $userId'),
      ),
    );
  }
}