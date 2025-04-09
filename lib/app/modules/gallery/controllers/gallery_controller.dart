import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  var images = <String>[].obs;
  var isLoading = false.obs;

  final SupabaseClient _client = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Obtener el UID del usuario actual
  String get userUid => _client.auth.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> fetchImages() async {
    if (userUid.isEmpty) {
      Get.snackbar('Error', 'User not authenticated', 
          colorText: Colors.white,
          backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      // Listar archivos solo en la carpeta del usuario
      final response = await _client.storage.from('gallery').list(
        path: userUid,
      );

      if (response.isNotEmpty) {
        images.value = response.map((file) {
          return _client.storage
              .from('gallery')
              .getPublicUrl('$userUid/${file.name}');
        }).toList();
      } else {
        images.clear();
        Get.snackbar('Info', 'No images found in your gallery',
            colorText: Colors.white,
            backgroundColor: Colors.blue);
      }
    } catch (e) {
      if (e.toString().contains('Not found')) {
        images.clear();
      } else {
        Get.snackbar('Error', 'Failed to load images: ${e.toString()}',
            colorText: Colors.white,
            backgroundColor: Colors.red);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeAndUploadPhoto() async {
  try {
    if (_client.auth.currentUser == null) {
      Get.snackbar('Error', 'You must be logged in to upload photos');
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    final Uint8List bytes = await photo.readAsBytes();
    final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '$userUid/$fileName';


    isLoading.value = true;

    // Manejo específico para Web
    if (GetPlatform.isWeb) {
      await _client.storage.from('gallery').uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
    } else {
      final File imageFile = File(photo.path);
      await _client.storage.from('gallery').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
    }

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


  Future<void> pickAndUploadPhoto() async {
    await _handleImagePick(ImageSource.gallery);
  }

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      if (userUid.isEmpty) {
        Get.snackbar('Error', 'You must be logged in to upload photos',
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return;
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      isLoading.value = true;
      final Uint8List bytes = await image.readAsBytes();

      // Generar nombre único para el archivo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = image.path.split('.').last.toLowerCase();
      final fileName = 'image_$timestamp.$extension';
      final filePath = '$userUid/$fileName';

      // Subir la imagen a la carpeta del usuario
      await _client.storage.from('gallery').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'image/$extension',
            ),
          );

      // Actualizar la lista de imágenes
      await fetchImages();
      
      Get.snackbar('Success', 'Photo uploaded successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: ${e.toString()}',
          colorText: Colors.white,
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      if (userUid.isEmpty) {
        Get.snackbar('Error', 'You must be logged in to delete photos',
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return;
      }

      // Extraer el nombre del archivo de la URL
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      final fileName = segments.last;
      final filePath = '$userUid/$fileName';

      isLoading.value = true;
      await _client.storage.from('gallery').remove([filePath]);

      // Actualizar la lista de imágenes
      await fetchImages();
      
      Get.snackbar('Success', 'Photo deleted successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete photo: ${e.toString()}',
          colorText: Colors.white,
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}