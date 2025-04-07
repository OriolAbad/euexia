import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
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
  RxString searchQuery = "".obs;
  var filteredMarkers =
      <LatLng>[].obs; // // Lista filtrada de marcadores (observable)
  RxList<Map<String, dynamic>> gymsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredGyms = <Map<String, dynamic>>[].obs;

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
          .select('idgimnasio, nombre, latitud, longitud, ubicacion');

      if (response == null) {
        print("La respuesta de Supabase es nula");
        return;
      }

      // Conversión explícita del tipo
      final List<Map<String, dynamic>> gyms =
          List<Map<String, dynamic>>.from(response);

      if (gyms.isEmpty) {
        print("No hay gimnasios en la base de datos");
        return;
      }

      gymsList.assignAll(gyms);
      filteredGyms.assignAll(gyms);
      markers.clear();

      // Añade los nuevos marcadores desde la base de datos
      for (final gimnasio in gyms) {
        if (gimnasio['latitud'] != null && gimnasio['longitud'] != null) {
          addMarker(LatLng(double.parse(gimnasio['latitud'].toString()),
              double.parse(gimnasio['longitud'].toString())));
        }
      }
    } catch (e) {
      print('Error al obtener los gimnasios: $e');
      Get.snackbar('Error', 'Error al cargar gimnasios: ${e.toString()}');
    }
  }

  void filterGyms() {
    if (searchQuery.value.isEmpty) {
      filteredGyms.assignAll(gymsList);
    } else {
      filteredGyms.assignAll(gymsList
          .where((gym) =>
              gym['nombre']
                  ?.toString()
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false)
          .toList());
    }
  }

  void onGymSelected(Map<String, dynamic> selectedGym) {
    if (selectedGym['latitud'] != null && selectedGym['longitud'] != null) {
      searchLocationOnMap(selectedGym['latitud'], selectedGym['longitud']);
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

  // Método para moverse a una ubicación
  Future<void> searchLocationOnMap(double latitud, double longitud) async {
    try {
      final newLocation = LatLng(latitud, longitud);

      // Actualizar la ubicación de búsqueda
      searchLocation.value = newLocation;

      // Mover el mapa a las nuevas coordenadas
      mapController.move(newLocation, 15.0);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo mover al punto: $e');
    }
  }

  // Método para agregar un marcador
  void addMarker(LatLng point) {
    markers.add(point); // Agregar marcador a la lista
  }

  // Método para centrar el mapa en la ubicación actual del usuario
  Future<void> centerMapOnUserLocation() async {
    searchLocation.value = LatLng(41.382894, 2.177432); // Barcelona, España
    mapController.move(searchLocation.value!, 12.0); // Mover el mapa
  }
}
