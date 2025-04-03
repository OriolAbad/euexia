import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart'; // Importa flutter_map
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapControllerX extends GetxController {
  final MapController mapController =
      MapController(); // Controlador de flutter_map
  final TextEditingController searchController =
      TextEditingController(); // Controlador del campo de búsqueda
  Rx<LatLng?> searchLocation =
      Rx<LatLng?>(null); // Ubicación buscada (observable)
  RxList<LatLng> markers = <LatLng>[].obs; // Lista de marcadores (observable)
  

  @override
  void onInit() {
    super.onInit();
    fetchMarkers(); // Llama a la función para obtener los marcadores
  }

  void fetchMarkers() async {
    final supabase = Supabase.instance.client;
    try {
      // Realiza la consulta a la tabla gimnasios
      final response = await supabase
          .from('gimnasios')
          .select('latitud, longitud');

      if (response == null || response.isEmpty) {
        print("No hay gimnasios en la base de datos");
        return;
      }

      // Limpia los marcadores existentes
      markers.clear();

      // Añade los nuevos marcadores desde la base de datos
      for (final gimnasio in response) {
        addMarker(LatLng(
            gimnasio['latitud'], gimnasio['longitud'])); // Agrega el marcador
      }
    } catch (e) {
      print('Error al obtener los gimnasios: $e');
    }
  }

  // Método para aumentar el zoom
  void zoomIn() {
    final double currentZoom = mapController.zoom;
    mapController.move(
        mapController.center, currentZoom + 1); // Aumentar zoom en 1
  }

  // Método para disminuir el zoom
  void zoomOut() {
    final double currentZoom = mapController.zoom;
    mapController.move(
        mapController.center, currentZoom - 1); // Disminuir zoom en 1
  }

  // Método para buscar una ubicación
  Future<void> searchLocationOnMap() async {
    try {
      List<Location> locations =
          await locationFromAddress(searchController.text);
      if (locations.isNotEmpty) {
        searchLocation.value =
            LatLng(locations[0].latitude, locations[0].longitude);
        mapController.move(searchLocation.value!,
            12.0); // Mover el mapa a la ubicación buscada
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
    searchLocation.value = LatLng(41.382894, 2.177432); // Barcelona, España
    mapController.move(searchLocation.value!, 12.0); // Mover el mapa
  }
}
