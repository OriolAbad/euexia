import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  var images = <String>[].obs;
  var isLoading = false.obs;

  final SupabaseClient client = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final response = await client.storage.from('gallery').list();

      if (response.isNotEmpty) {
        images.value = response.map((file) {
          return client.storage.from('gallery').getPublicUrl(file.name);
        }).toList();
      } else {
        Get.snackbar('Error', 'No images found', colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeAndUploadPhoto() async {
    await _handleImagePick(ImageSource.camera);
  }

  Future<void> pickAndUploadPhoto() async {
    await _handleImagePick(ImageSource.gallery);
  }

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      if (client.auth.currentUser == null) {
        Get.snackbar('Error', 'You must be logged in to upload photos');
        return;
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();
      isLoading.value = true;

      final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Always use uploadBinary for all platforms
      await client.storage.from('gallery').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      await fetchImages();
      Get.snackbar('Success', 'Photo uploaded successfully!', colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: $e', colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}