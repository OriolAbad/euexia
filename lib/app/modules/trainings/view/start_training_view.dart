import 'package:euexia/app/data/models/rutinas.dart';
import 'package:flutter/material.dart';

class StartTrainingView extends StatelessWidget {
  final Rutina rutina; // Recibe la rutina como argumento

  const StartTrainingView({super.key, required this.rutina});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Training: ${rutina.nombre}'), // Muestra el nombre de la rutina
      ),
      body: Center(
        child: Text('Rutina: ${rutina.descripcion ?? "Sin descripción"}'), // Muestra la descripción de la rutina
      ),
    );
  }
}