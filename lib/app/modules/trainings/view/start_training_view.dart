import 'dart:async';
import 'package:euexia/app/data/models/rutinas.dart';
import 'package:flutter/material.dart';

class StartTrainingView extends StatefulWidget {
  final Rutina rutina; // Recibe la rutina como argumento

  const StartTrainingView({super.key, required this.rutina});

  @override
  _StartTrainingViewState createState() => _StartTrainingViewState();
}

class _StartTrainingViewState extends State<StartTrainingView> {
  int countdown = 3; // Contador inicial

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel(); // Detener el temporizador cuando llegue a 1
        setState(() {
          countdown = 0; // Cambiar a 0 para mostrar el contenido principal
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Start Training: ${widget.rutina.nombre}'
        ),
      ),
      body: countdown > 0
          ? Center(
              child: Text(
                '$countdown', // Mostrar el contador
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Center(
              child: Text(
                'Rutina: ${widget.rutina.descripcion ?? "Sin descripción"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}