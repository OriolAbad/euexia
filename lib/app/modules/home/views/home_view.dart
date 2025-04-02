import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:fl_chart/fl_chart.dart'; // para gráficos
import 'package:carousel_slider/carousel_slider.dart'; // para carrusel
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // Crear un GlobalKey para el Scaffold
  final HomeController controller = Get.find<HomeController>(tag: 'home'); //

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
              leading: const Icon(Icons.format_list_bulleted, color: Colors.black),
              title: const Text('Rutinas',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offAllNamed(Routes.RUTINAS);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.black),
              title: const Text('Ejercicios',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.offAllNamed(Routes.EJERCICIOS);
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
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Contenedor QR
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      if (controller.isLoadingQr.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.qrData.value.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_2,
                                size: 36, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text('QR no disponible',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            TextButton(
                              onPressed: controller.fetchUserQrData,
                              child: const Text('Generar QR',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        );
                      }

                      return QrImageView(
                        data: controller.qrData.value,
                        version: QrVersions.auto,
                        size: 150.0,
                        padding: const EdgeInsets.all(10),
                      );
                    }),
                  ),

                  const SizedBox(width: 24),

                  // Botón Train con texto abajo a la izquierda
                  GestureDetector(
                    onTap: () {
                      print("Train button pressed");
                      // Aquí tu lógica para el botón Train
                    },
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF4CAF50).withOpacity(0.9),
                            const Color(0xFF2E7D32),
                          ],
                        ),
                      ),
                      child: const Stack(
                        children: [
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: Text(
                              'TRAIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Carrusel ultra-optimizado (sin fondos grises)
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.featuredTips.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay consejos destacados',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              return CarouselSlider.builder(
                itemCount: controller.featuredTips.length,
                options: CarouselOptions(
                  height: 220.0,
                  autoPlay: true,
                  viewportFraction: 0.92,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 6),
                  pauseAutoPlayOnManualNavigate: true,
                  onPageChanged: (index, _) =>
                      controller.preloadNextBatch(index),
                ),
                itemBuilder: (context, index, _) {
                  final tip = controller.featuredTips[index];
                  final imageUrl = tip['full_image_url'] as String?;

                  return FutureBuilder<bool>(
                    future: controller.isImagePreloaded(imageUrl),
                    builder: (context, snapshot) {
                      final isPreloaded = snapshot.data ?? false;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: isPreloaded && imageUrl != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    imageUrl,
                                    maxWidth: 600, // Optimización para tamaño
                                    maxHeight: 400,
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.35),
                                    BlendMode.darken,
                                  ),
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Fondo de precarga sutil
                            if (!isPreloaded || imageUrl == null)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900]!.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),

                            // Contenido del consejo
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  tip['descripcion'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 12.0,
                                        color: Colors.black87,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
    if (Platform.isAndroid || Platform.isIOS) {
      Get.toNamed(Routes.QR);
    } else {
      Get.snackbar(
        'Función no disponible',
        'El escaneo QR solo está disponible en dispositivos móviles',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: const Color(0xFFD32F2F),
      );
    }
  },
        backgroundColor: const Color(0xFF4CAF50), // Verde lima
        child: const Icon(Icons.qr_code, color: Colors.white),
      ),
    );
  }
}
