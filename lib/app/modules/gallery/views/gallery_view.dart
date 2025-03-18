import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:euexia/app/modules/gallery/controllers/gallery_controller.dart';

class GalleryView extends StatelessWidget {
  final GalleryController controller = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Fondo negro grafito
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF212121), // Fondo negro grafito
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white, // Indicador de carga blanco
            ),
          );
        } else if (controller.images.isEmpty) {
          return const Center(
            child: Text(
              'No images found',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1, // Ajusta la relación de aspecto según sea necesario
            ),
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navegar a la vista de imagen a pantalla completa
                  Get.to(() => FullScreenImageView(imageUrl: controller.images[index]));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2), // Borde sutil
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    child: CachedNetworkImage(
                      imageUrl: controller.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.white, // Indicador de carga blanco
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.white, // Icono de error blanco
                      ),
                    ),
                  ),
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
      backgroundColor: const Color(0xFF212121), // Fondo negro grafito
      appBar: AppBar(
        title: const Text(
          'Image View',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF212121), // Fondo negro grafito
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}