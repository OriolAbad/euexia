import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/exercises/controllers/exercises_controller.dart';

class ExercisesView extends StatelessWidget {
  final ExercisesController controller = Get.find<ExercisesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Exercises",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(Routes.HOME); // Vuelve a la pantalla anterior
            // Vuelve a la pantalla anterior
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              // Acción del botón '+' (de momento no hace nada)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Buscador
            TextField(
              decoration: InputDecoration(
                hintText: "Search exercises",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                controller.searchQuery.value =
                    value; // Actualiza el valor de searchQuery
                controller
                    .filterEjercicios(); // Llama a la función para filtrar
              },
            ),
            const SizedBox(height: 16),
            // ComboBox para categorías
            Obx(() {
              final categorias = controller.categorias;
              return DropdownButton<int>(
                value: controller
                    .selctedCategoryId.value, // Observa el valor seleccionado
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<int>(
                    value: 0,
                    child: Text("All Categories"),
                  ),
                  ...categorias.map((categoria) => DropdownMenuItem<int>(
                        value: categoria.idCategoria,
                        child: Text(categoria.nombre),
                      )),
                ],
                onChanged: (value) {
                  controller.selctedCategoryId.value =
                      value ?? 0; // Actualiza el valor seleccionado
                  controller
                      .filterEjercicios(); // Llama a la función para filtrar
                },
              );
            }),
            const SizedBox(height: 16),
            // Lista de ejercicios filtrados
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }
                if (controller.filteredEjercicios.isEmpty) {
                  return const Center(
                    child: Text(
                      "No exercises found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredEjercicios.length,
                  itemBuilder: (context, index) {
                    final ejercicio = controller.filteredEjercicios[index];
                    return GestureDetector(
                      onTap: () {
                        // Devuelve el objeto ejercicio seleccionado
                        Get.back(result: ejercicio);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fitness_center,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ejercicio.nombre,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Category: ${ejercicio.categoria?.nombre}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
