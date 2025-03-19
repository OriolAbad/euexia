import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/map/controllers/map_controller.dart'; // Importa el controlador

// Token de Mapbox
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1Ijoib3Jpb2xhYmFkIiwiYSI6ImNtODk0NmU4ZDEwbDUyanIzdmhza2F3YjIifQ.nG7KPJ5kocu-dcih-UaoiQ';

class MapView extends StatelessWidget {
  final MapControllerX mapControllerX = Get.put(MapControllerX()); // Inicializa el controlador

  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gym Map',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: mapControllerX.centerMapOnUserLocation, // Centrar en la ubicación del usuario
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: mapControllerX.searchController,
              decoration: InputDecoration(
                hintText: 'Buscar ubicación...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: mapControllerX.searchLocationOnMap, // Buscar ubicación
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Mapa
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => FlutterMap(
                        mapController: mapControllerX.mapController,
                        options: MapOptions(
                          center: mapControllerX.searchLocation.value ?? LatLng(41.382894, 2.177432), // Barcelona o ubicación buscada
                          zoom: 10,
                          minZoom: 3,
                          maxZoom: 18,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=$MAPBOX_ACCESS_TOKEN',
                            additionalOptions: const {
                              'accessToken': MAPBOX_ACCESS_TOKEN,
                              'id': 'mapbox/streets-v12'
                            },
                          ),
                          MarkerLayer(
                            markers: mapControllerX.markers
                                .map((point) => Marker(
                                      point: point,
                                      width: 40,
                                      height: 40,
                                      builder: (context) => const Icon(
                                        Icons.location_pin,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      )),
                ),
                // Botones de zoom
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          mapControllerX.zoomIn(); // Aumentar zoom
                        },
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          mapControllerX.zoomOut(); // Disminuir zoom
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}