import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/gallery/controllers/gallery_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryView extends StatelessWidget {
  final GalleryController controller = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.images.isEmpty) {
          return Center(child: Text('No images found'));
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1, // Adjust aspect ratio as needed
            ),
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to full screen image view
                  Get.to(() => FullScreenImageView(imageUrl: controller.images[index]));
                },
                child: CachedNetworkImage(
                  imageUrl: controller.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}