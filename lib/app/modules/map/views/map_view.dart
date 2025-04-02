import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/map/controllers/map_controller.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1Ijoib3Jpb2xhYmFkIiwiYSI6ImNtODk0NmU4ZDEwbDUyanIzdmhza2F3YjIifQ.nG7KPJ5kocu-dcih-UaoiQ';

class MapView extends StatelessWidget {
  final MapControllerX mapControllerX = Get.put(MapControllerX());

  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro como en ExercisesView
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Gym Map',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.blue),
            onPressed: mapControllerX.centerMapOnUserLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Nueva barra de búsqueda estilo ExercisesView
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: mapControllerX.searchController,
              decoration: InputDecoration(
                hintText: "Search location...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                // Puedes implementar búsqueda en tiempo real aquí si lo deseas
                // mapControllerX.searchLocationOnMap(value);
              },
              onSubmitted: (value) {
                mapControllerX.searchLocationOnMap();
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => FlutterMap(
                        mapController: mapControllerX.mapController,
                        options: MapOptions(
                          center: mapControllerX.searchLocation.value ?? 
                              LatLng(41.382894, 2.177432),
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in_btn',
                        mini: true,
                        backgroundColor: Colors.grey[800],
                        onPressed: mapControllerX.zoomIn,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'zoom_out_btn',
                        mini: true,
                        backgroundColor: Colors.grey[800],
                        onPressed: mapControllerX.zoomOut,
                        child: const Icon(Icons.remove, color: Colors.white),
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