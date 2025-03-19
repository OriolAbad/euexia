import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  var images = <String>[].obs; // Lista de URLs de imágenes
  var isLoading = false.obs; // Estado de carga

  final SupabaseClient client = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchImages(); // Cargar imágenes al iniciar
  }

  // Método para obtener las imágenes del bucket
  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final response = await client.storage.from('gallery').list();

      if (response.isNotEmpty) {
        // Extraer URLs públicas de los archivos
        images.value = response.map((file) {
          return client.storage.from('gallery').getPublicUrl(file.name);
        }).toList();
      } else {
        Get.snackbar(
          'Error',
          'No images found',
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Método para tomar una foto y subirla
  Future<void> takeAndUploadPhoto() async {
    try {
      // Verificar autenticación
      if (client.auth.currentUser == null) {
        Get.snackbar('Error', 'You must be logged in to upload photos');
        return;
      }

      // Tomar una foto
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      // Leer el archivo como bytes
      final Uint8List bytes = await photo.readAsBytes();

      // Subir la imagen
      isLoading.value = true;
      final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Verificar si es web
      if (GetPlatform.isWeb) {
        await client.storage.from('gallery').uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
      } else {
       final File imageFile = File(photo.path);
        await client.storage.from('gallery').upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
      }

      // Actualizar la galería
      await fetchImages();

      Get.snackbar(
        'Success',
        'Photo uploaded successfully!',
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload photo: $e',
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}