import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/exercises/controllers/exercises_controller.dart';

class ExercisesView extends StatelessWidget {
  final ExercisesController controller = Get.find<ExercisesController>();

  ExercisesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Ejercicios",
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
            icon: const Icon(Icons.add, color: Color(0xFFD32F2F)),
            onPressed: () {
              showAddExerciseModal(context, controller);
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
                hintText: "Buscar ejercicio",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD32F2F)),
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
                    child: Text("Todas las categorías"),
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
                    child: CircularProgressIndicator(color: Color(0xFFD32F2F)),
                  );
                }
                if (controller.filteredEjercicios.isEmpty) {
                  return const Center(
                    child: Text(
                      "Ejercicios no encontrados",
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
                                color: Color(0xFFD32F2F),
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
                                    "Categoría: ${ejercicio.categoria?.nombre}",
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

void showAddExerciseModal(BuildContext context, ExercisesController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Añadir ejercicio",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Campo de texto para el nombre del ejercicio
            TextField(
              onChanged: (value) {
                controller.ejercicio.value.nombre = value;
              },
              decoration: InputDecoration(
                labelText: "Nombre del ejercicio",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Campo de texto largo para la descripción
            TextField(
              onChanged: (value) {
                controller.ejercicio.value.descripcion = value;
              },
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Descripción",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // ComboBox para seleccionar la categoría
            Obx(() {
              final categorias = controller.categorias;

              // Verifica si el valor actual está en la lista de categorías
              final selectedValue = categorias.any((categoria) => categoria.idCategoria == controller.ejercicio.value.idCategoria)
                  ? controller.ejercicio.value.idCategoria
                  : null;

              return DropdownButton<int>(
                value: selectedValue, // Asegúrate de que el valor esté en la lista
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                isExpanded: true,
                items: categorias.map((categoria) {
                  return DropdownMenuItem<int>(
                    value: categoria.idCategoria,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.ejercicio.value.idCategoria = value ?? 0; // Actualiza idCategoria
                  controller.ejercicio.refresh(); // Refresca el observable para reflejar los cambios
                },
                hint: const Text(
                  "Seleccionar categoría",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }),
            const SizedBox(height: 24),
            // Botón para guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  showConfirmationModal(context, controller);
                },
                child: const Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showConfirmationModal(BuildContext context, ExercisesController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Confirmación",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "¿Estás seguro que deseas añadir este ejercicio? No se podrá ni editar ni eliminar más tarde.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra la modal sin hacer nada
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      await controller.addEjercicio(); // Llama a la función para añadir el ejercicio
                      Navigator.of(context).pop(); // Cierra la modal después de confirmar
                      Navigator.of(context).pop(); // Cierra la modal después de confirmar
                    },
                    child: const Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}




