import 'dart:convert';
import 'package:http/http.dart' as http;

// FALTA AGREGAR EL SERVICE PARA BUSCAR UBICACIONES Y QUE SE SUGIERA MIENTRAS BUSCAS
class MapBoxService {
  final String accessToken;

  MapBoxService(this.accessToken);

  // Método para obtener sugerencias de ubicaciones
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$accessToken&limit=5';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> features = data['features'];
        return features.map((feature) {
          return {
            'name': feature['place_name'],
            'latitude': feature['center'][1],
            'longitude': feature['center'][0],
          };
        }).toList();
      } else {
        throw Exception('Error al obtener sugerencias');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}