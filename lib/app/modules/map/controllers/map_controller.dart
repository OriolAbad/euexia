import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart'; // Importa flutter_map
import 'package:flutter/material.dart';

class MapControllerX extends GetxController {
  final MapController mapController = MapController(); // Controlador de flutter_map
  final TextEditingController searchController = TextEditingController(); // Controlador del campo de búsqueda
  Rx<LatLng?> searchLocation = Rx<LatLng?>(null); // Ubicación buscada (observable)
  RxList<LatLng> markers = <LatLng>[].obs; // Lista de marcadores (observable)

  // Método para aumentar el zoom
  void zoomIn() {
    final double currentZoom = mapController.zoom;
    mapController.move(mapController.center, currentZoom + 1); // Aumentar zoom en 1
  }

  // Método para disminuir el zoom
  void zoomOut() {
    final double currentZoom = mapController.zoom;
    mapController.move(mapController.center, currentZoom - 1); // Disminuir zoom en 1
  }

  // Método para buscar una ubicación
  Future<void> searchLocationOnMap() async {
    try {
      List<Location> locations = await locationFromAddress(searchController.text);
      if (locations.isNotEmpty) {
        searchLocation.value = LatLng(locations[0].latitude, locations[0].longitude);
        mapController.move(searchLocation.value!, 12.0); // Mover el mapa a la ubicación buscada
        markers.add(searchLocation.value!); // Agregar marcador
      } else {
        Get.snackbar('Error', 'Ubicación no encontrada');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al buscar la ubicación: ${e.toString()}');
    }
  }

  // Método para agregar un marcador al hacer clic en el mapa
  void addMarker(LatLng point) {
    markers.add(point); // Agregar marcador a la lista
  }

  // Método para centrar el mapa en la ubicación actual del usuario
  Future<void> centerMapOnUserLocation() async {
    // Aquí puedes usar el paquete `geolocator` para obtener la ubicación actual del usuario
    // Por ahora, usaremos una ubicación fija como ejemplo
    searchLocation.value = LatLng(40.4168, -3.7038); // Madrid, España
    mapController.move(searchLocation.value!, 12.0); // Mover el mapa
  }
}