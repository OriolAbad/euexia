import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class PomodoroController extends GetxController {
  var series = 2.obs;
  var descanso = 60.obs; // 60 segundos por defecto
  var seriesCompletadas = 0.obs;
  var isResting = false.obs;
  Timer? timer;

  void startRest() {
    if (seriesCompletadas.value < series.value) {
      isResting.value = true;
      int remainingTime = descanso.value;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          remainingTime--;
          descanso.value = remainingTime;
        } else {
          timer.cancel();
          isResting.value = false;
          seriesCompletadas.value++;
          descanso.value = 60; // Reinicia el descanso
        }
      });
    }
  }

  void cancelTraining() {
    timer?.cancel();
    Get.offAllNamed('/home');
  }
}

class PomodoroView extends StatelessWidget {
  final int series;
  final int descanso;

  PomodoroView({Key? key, required this.series, required this.descanso}) : super(key: key);

  final PomodoroController controller = Get.put(PomodoroController());

  @override
  Widget build(BuildContext context) {
    controller.series.value = series;
    controller.descanso.value = descanso;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Pomodoro", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => controller.cancelTraining(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  "Series completadas: ${controller.seriesCompletadas}/${controller.series}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
            SizedBox(height: 20),
            Obx(() => controller.isResting.value
                ? Text(
                    "Descanso: ${controller.descanso.value}s",
                    style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : ElevatedButton(
                    onPressed: controller.startRest,
                    child: Text("Iniciar descanso"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  )),
            SizedBox(height: 20),
            Obx(() => controller.seriesCompletadas.value >= controller.series.value
                ? ElevatedButton(
                    onPressed: controller.cancelTraining,
                    child: Text("Felicidades, has terminado!"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  )
                : SizedBox()),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.cancelTraining,
              child: Text("Cancelar"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
