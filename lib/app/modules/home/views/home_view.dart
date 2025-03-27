import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:fl_chart/fl_chart.dart'; // para gráficos
import 'package:carousel_slider/carousel_slider.dart'; // para carrusel

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // Crear un GlobalKey para el Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignar el GlobalKey al Scaffold
      backgroundColor: Color(0xFF212121), // Fondo gris claro
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F), // Rojo intenso
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Usar el GlobalKey para abrir el Drawer
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          // Botón para navegar al perfil del usuario
          IconButton(
            onPressed: () async {
              Get.toNamed(Routes.SETTINGS);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF212121), // Negro grafito
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title:
                  const Text('Inicio', style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offNamed(Routes.HOME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('My Profile',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offNamed(Routes.PROFILE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.black),
              title: const Text('My Exercices',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                //Get.toNamed(Routes.EXERCICES);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.black),
              title:
                  const Text('Gym Map', style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.toNamed(Routes.MAP);
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes, color: Colors.black),
              title: const Text('Challenges',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offAllNamed(Routes.CHALLENGES);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.black),
              title: const Text('Tips', style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.toNamed(Routes.TIPS);
              },
            ),
             ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Rutinas',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offAllNamed(Routes.RUTINAS);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offAllNamed(Routes.LOGIN);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gráfico de ejemplo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200, // Altura definida para evitar problemas de layout
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 1),
                          FlSpot(1, 3),
                          FlSpot(2, 2),
                          FlSpot(3, 5),
                          FlSpot(4, 3),
                          FlSpot(5, 4),
                          FlSpot(6, 3),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Contenedores para botones
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    color: const Color(0xFF4CAF50), // Verde lima
                    child: const Center(
                      child: Text(
                        'Button 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 100,
                    color: const Color(0xFF4CAF50), // Verde lima
                    child: const Center(
                      child: Text(
                        'Button 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Carrusel corregido con LayoutBuilder
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CarouselSlider(
                    options: CarouselOptions(height: 200.0),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Container(
                        width: constraints.maxWidth, // Tamaño seguro
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: Colors.amber),
                        child: Center(
                          child: Text(
                            'Image $i',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50), // Verde lima
        onPressed: () => Get.toNamed(Routes.ADD_NOTE),
        child: const Icon(Icons.add),
      ),
    );
  }
}
