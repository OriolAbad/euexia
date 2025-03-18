import 'dart:io';
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

      // Convertir XFile a File
      final File imageFile = File(photo.path);

      // Subir la imagen
      isLoading.value = true;
      final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage.from('gallery').upload(fileName, imageFile);

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