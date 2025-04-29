import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';

class StatsView extends StatelessWidget {
  StatsView({Key? key}) : super(key: key);
  final StatsController controller = Get.put(StatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('TUS ESTADÍSTICAS', 
               style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.records.isEmpty) {
          return const Center(
            child: Text(
              "No tienes records registrados",
              style: TextStyle(color: Colors.white, fontSize: 18),
          ));
        }

        return Center( // Widget Center añadido aquí
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container( // Container para márgenes
              margin: const EdgeInsets.symmetric(vertical: 20), // Margen vertical
              child: DataTable(
                columnSpacing: 40,
                dataRowHeight: 60,
                headingTextStyle: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
                dataTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14
                ),
                columns: const [
                  DataColumn(label: Text('Ejercicio')),
                  DataColumn(label: Text('Record')),
                ],
                rows: controller.records.map((record) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(record.ejercicio?.nombre ?? "Sin nombre",
                          style: const TextStyle(color: Colors.white))
                      ),
                      DataCell(
                        Text(record.record?.toString() ?? "--",
                          style: const TextStyle(color: Colors.white))
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}