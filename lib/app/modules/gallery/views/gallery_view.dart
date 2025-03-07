import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/gallery/controllers/gallery_controller.dart';

class GalleryView extends StatelessWidget {
  GalleryView({super.key});

  final GalleryController controller = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.images.isEmpty) {
          return const Center(child: Text('No images found', style: TextStyle(color: Colors.white)));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              final imageUrl = controller.getImageUrl(controller.images[index]);

              if (imageUrl != null) {
                return Image.network(imageUrl, fit: BoxFit.cover);
              } else {
                return const Center(child: Text('Error loading image'));
              }
            },
          );
        }
      }),
      backgroundColor: const Color(0xFF212121),
    );
  }
}
