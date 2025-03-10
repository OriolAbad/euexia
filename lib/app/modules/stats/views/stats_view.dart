// lib/views/stats_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/stats_controller.dart';

class StatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StatsController controller =Get.put(StatsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Stats", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Bench Press",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text("Total Volume (kg)", style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            _buildLineChart(controller.totalVolumeData),

            SizedBox(height: 20),

            Text("Best Set (1Rm)", style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            _buildLineChart(controller.bestSetData),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(RxList<Map<String, dynamic>> data) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < data.length) {
                        return Text(data[value.toInt()]["day"] ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 12));
                      }
                      return Text("");
                    },
                    reservedSize: 22,
                  ),
                ),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)),
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value["weight"].toDouble());
                  }).toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          )),
    );
  }
}
