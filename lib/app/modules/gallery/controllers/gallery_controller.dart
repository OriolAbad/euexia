import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class GalleryController extends GetxController {
  var images = <String>[].obs;
  var isLoading = false.obs;

  final SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  // Fetch images from the Supabase storage bucket
  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final response = await client.storage.from('prueba').list();

      if (response.isNotEmpty) {
        // Extract image names from response data
        images.value = response.map((file) => file.name).toList();
      } else {
        // Show error if response is empty
        Get.snackbar(
          'Error',
          'No images found',
          colorText: Colors.white, // Change the text color to white
        );
      }
    } catch (e) {
      // Handle any exceptions
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        colorText: Colors.white, // Change the text color to white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get public URL for an image in Supabase storage
  String? getImageUrl(String imageName) {
    final urlResponse = client.storage.from('prueba').getPublicUrl(imageName);

    if (urlResponse != null) {
      return urlResponse;
    } else {
      return null; // Return null if URL is not available
    }
  }
}
