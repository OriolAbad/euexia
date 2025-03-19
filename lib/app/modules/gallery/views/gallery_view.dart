import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gallery_controller.dart';

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GalleryController controller = Get.put(GalleryController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Gallery", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen destacada (Primera imagen de Supabase en slider)
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.images.isEmpty) {
                return Center(
                  child: Text(
                    "No images available",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return Container(
                height: 200,
                child: PageView(
                  children: controller.images
                      .map((imageUrl) => Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
                            },
                          ))
                      .toList(),
                ),
              );
            }),
            SizedBox(height: 10),

            // Botón para agregar una nueva foto desde la cámara o galería
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => controller.takeAndUploadPhoto(),
                  child: Text("Camera"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controller.pickAndUploadPhoto(), // Nuevo método para seleccionar archivos
                  child: Text("Gallery"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Cuadrícula de imágenes desde Supabase
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.images.isEmpty) {
                  return Center(
                    child: Text(
                      "No images in gallery",
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

                    return Container(
                      color: Colors.grey[800],
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
                        },
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
}
