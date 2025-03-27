import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  final RxList<Map<String, dynamic>> featuredTips = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final List<String> _imageExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  Future<void> fetchFeaturedTips() async {
    try {
      isLoading.value = true;
      final response = await client
          .from('consejos')
          .select('idconsejo, descripcion, imagen')
          .eq('destacado', true)
          .order('idconsejo', ascending: true);

      if (response != null && response.isNotEmpty) {
        final tipsWithImages = await Future.wait(
          (response as List).map<Future<Map<String, dynamic>>>((tip) async {
            // Si ya hay una URL en la base de datos, la usamos
            if (tip['imagen'] != null && tip['imagen'].toString().isNotEmpty) {
              return {...tip as Map<String, dynamic>, 'full_image_url': tip['imagen']};
            }
            
            // Si no, probamos con diferentes extensiones
            final imageUrl = await _findImageUrl(tip['idconsejo']);
            return {...tip as Map<String, dynamic>, 'full_image_url': imageUrl};
          }),
        );
        
        featuredTips.assignAll(tipsWithImages.where((tip) => tip['full_image_url'] != null));
      } else {
        featuredTips.clear();
      }
    } catch (e) {
      featuredTips.clear();
      Get.snackbar('Error', 'No se pudieron cargar los consejos: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _findImageUrl(int tipId) async {
    try {
      // Primero intentamos sin extensión (por si acaso)
      final baseUrl = client.storage
          .from('consejos')
          .getPublicUrl('consejos_$tipId');
      
      // Verificamos si la URL sin extensión funciona
      final response = await _checkImageExists(baseUrl);
      if (response) return baseUrl;

      // Si no, probamos con cada extensión
      for (final ext in _imageExtensions) {
        final url = client.storage
            .from('consejos')
            .getPublicUrl('consejos_$tipId$ext');
        
        if (await _checkImageExists(url)) {
          return url;
        }
      }
      
      return null;
    } catch (e) {
      return null;  
    }
  }

  Future<bool> _checkImageExists(String url) async {
    try {
      final response = await client.storage
          .from('consejos')
          .createSignedUrl(url.split('/').last, 60); // URL válida por 60 segundos
      return response != null;
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    fetchFeaturedTips();
    super.onInit();
  }
}