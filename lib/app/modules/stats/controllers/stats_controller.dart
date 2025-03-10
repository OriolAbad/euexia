// lib/controllers/stats_controller.dart
import 'package:get/get.dart';

class StatsController extends GetxController {
  // Datos ficticios de estadísticas (sustituir con datos reales de la base de datos)
  var totalVolumeData = [
    {"day": "1jan", "weight": 50},
    {"day": "2jan", "weight": 55},
    {"day": "3jan", "weight": 53},
    {"day": "4jan", "weight": 60},
    {"day": "5jan", "weight": 65},
    {"day": "6jan", "weight": 70},
  ].obs;

  var bestSetData = [
    {"reps": 10, "weight": 50},
    {"reps": 20, "weight": 55},
    {"reps": 30, "weight": 53},
    {"reps": 40, "weight": 60},
    {"reps": 50, "weight": 65},
    {"reps": 60, "weight": 70},
  ].obs;

  // Simulación de obtención de datos desde la base de datos
  Future<void> fetchStatsFromDB() async {
    // Aquí se haría la consulta real a la base de datos
    await Future.delayed(Duration(seconds: 2)); // Simula espera de la BD

    // Ejemplo: Obtener datos de la tabla dias_entrenados
    // final result = await database.query("dias_entrenados", where: "idusuario = ?", whereArgs: [usuarioId]);
    // totalVolumeData.value = result.map((e) => {"day": e["fechaentrenamiento"], "weight": e["peso"]}).toList();
  }

  @override
  void onInit() {
    fetchStatsFromDB();
    super.onInit();
  }
}
