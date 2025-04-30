import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gallery_controller.dart';
import 'dart:io';
import 'dart:async';

class GalleryView extends StatefulWidget {
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final GalleryController controller = Get.put(GalleryController());
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && controller.images.isNotEmpty) {
        final nextPage =
            (_pageController.page!.toInt() + 1) % controller.images.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Galería", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Flecha blanca
          onPressed: () {
            Navigator.of(context).pop(); // Acción para volver atrás
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.images.isEmpty) {
                return Center(
                  child: Text(
                    "No hay imágenes en la galería",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return Container(
                height: 200,
                child: PageView(
                  controller: _pageController,
                  children: controller.images
                      .map((imageUrl) => GestureDetector(
                            onTap: () => _showFullImage(context, imageUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.grey[800],
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.white, size: 50),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      controller.takeAndUploadPhoto();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "La cámara no está disponible en este dispositivo."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.camera_alt, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controller.pickAndUploadPhoto(),
                  child: Icon(Icons.upload, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.images.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay imágenes en la galería",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl = controller.images[index];

                    return GestureDetector(
                      onTap: () => _showFullImage(context, imageUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Colors.grey[800],
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.white, size: 40),
                                  );
                                },
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(
                                      context, imageUrl, controller),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white, size: 60),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, String imageUrl, GalleryController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Eliminar imagen", style: TextStyle(color: Colors.white)),
        content: Text("¿Estás seguro de que deseas eliminar esta imagen?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteImage(imageUrl);
            },
          ),
        ],
      ),
    );
  }
}
