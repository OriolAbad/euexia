import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  final RxList<Map<String, dynamic>> featuredTips = <Map<String, dynamic>>[].obs;

  // Obtener consejos destacados
  Future<void> fetchFeaturedTips() async {
    try {
      final response = await client
          .from('consejos')
          .select('idconsejo, descripcion') // Selecciona ambos campos
          .eq('destacado', true)
          .order('idconsejo', ascending: true); // Orden opcional

      if (response != null && response.isNotEmpty) {
        featuredTips.assignAll(List<Map<String, dynamic>>.from(response));
      } else {
        featuredTips.clear(); // Limpiar si no hay resultados
      }
    } catch (e) {
      featuredTips.clear(); // Limpiar en caso de error
      Get.snackbar('Error', 'No se pudieron cargar los consejos: ${e.toString()}');
    }
  }

  @override
  void onInit() {
    fetchFeaturedTips();
    super.onInit();
  }
}