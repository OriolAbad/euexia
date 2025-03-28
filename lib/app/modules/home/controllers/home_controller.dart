import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomeController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  final RxList<Map<String, dynamic>> featuredTips =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final List<String> _imageExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
  final Map<String, bool> _imagePreloadStatus = {};
  final DefaultCacheManager _cacheManager = DefaultCacheManager();
  final RxString qrData = ''.obs;
  final RxBool isLoadingQr = false.obs;

  // ========================
  // Gerador QR
  // ========================
  Future<void> fetchUserQrData() async {
    try {
      isLoadingQr.value = true;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await client
          .from('usuarios')
          .select('idusuario')
          .eq('uuid', user.id)
          .single();

      if (response != null && response['idusuario'] != null) {
        qrData.value = response['idUsuario'].toString();
      } else {
        throw Exception('ID de usuario no encontrado');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo obtener el ID para el QR: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      qrData.value = '';
    } finally {
      isLoadingQr.value = false;
    }
  }

  // ========================
  // 1. Carga inicial
  // ========================
  Future<void> fetchFeaturedTips() async {
    try {
      isLoading.value = true;
      final response = await client
          .from('consejos')
          .select('idconsejo, descripcion, imagen')
          .eq('destacado', true)
          .order('idconsejo', ascending: true);

      if (response != null && response.isNotEmpty) {
        featuredTips.assignAll(await _processTips(response));
        await _preloadInitialBatch();
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los consejos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _processTips(List response) async {
    return await Future.wait(
        response.map<Future<Map<String, dynamic>>>((tip) async {
      final imageUrl = await _resolveImageUrl(tip['imagen'], tip['idconsejo']);
      return {...tip as Map<String, dynamic>, 'full_image_url': imageUrl};
    }));
  }

  // ========================
  // 2. Gestión de imágenes
  // ========================
  Future<String?> _resolveImageUrl(dynamic storedUrl, int tipId) async {
    if (storedUrl != null && storedUrl.toString().isNotEmpty) return storedUrl;

    for (final ext in _imageExtensions) {
      try {
        final fileName = 'consejos_$tipId$ext';
        final url = client.storage.from('consejos').getPublicUrl(fileName);
        await client.storage.from('consejos').createSignedUrl(fileName, 60);
        return url;
      } catch (_) {}
    }
    return null;
  }

  // ========================
  // 3. Precarga inteligente (NUEVO)
  // ========================
  Future<void> preloadNextBatch(int currentIndex) async {
    final indicesToPreload = [
      currentIndex + 1,
      currentIndex + 2,
      currentIndex + 3,
      if (currentIndex > 0) currentIndex - 1,
    ].where((i) => i < featuredTips.length && i >= 0).toList();

    await Future.wait(indicesToPreload.map((i) {
      return _precacheImage(featuredTips[i]['full_image_url']);
    }));
  }

  Future<bool> isImagePreloaded(String? url) async {
    if (url == null) return false;
    return _imagePreloadStatus[url] ??= await _checkImageInCache(url);
  }

  Future<bool> _checkImageInCache(String url) async {
    try {
      final file = await _cacheManager.getFileFromCache(url);
      return file != null && await file.file.exists();
    } catch (_) {
      return false;
    }
  }

  // ========================
  // 4. Sistema de caché
  // ========================
  Future<void> _preloadInitialBatch() async {
    final initialIndices = List.generate(
        featuredTips.length < 4 ? featuredTips.length : 4, (i) => i);

    await Future.wait(initialIndices.map((i) {
      return _precacheImage(featuredTips[i]['full_image_url']);
    }));
  }

  Future<void> _precacheImage(String? url) async {
    if (url == null || _imagePreloadStatus[url] == true) return;

    try {
      await precacheImage(
        CachedNetworkImageProvider(url, cacheManager: _cacheManager),
        Get.context!,
        onError: (_, __) => _imagePreloadStatus[url] = false,
      );
      _imagePreloadStatus[url] = true;
    } catch (e) {
      _imagePreloadStatus[url] = false;
      debugPrint('Precache error for $url: $e');
    }
  }

  // ========================
  // Ciclo de vida
  // ========================
  @override
  void onClose() {
    _cacheManager.emptyCache();
    super.onClose();
  }

  @override
  void onInit() {
    fetchUserQrData();
    fetchFeaturedTips();
    super.onInit();
  }
}
