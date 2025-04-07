import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/categorias.dart';
import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  late List<Ejercicio> ejercicios;
  var categorias = <Categoria>[].obs; // Inicializar como lista reactiva vacía

  var selctedCategoryId = 0.obs; // Inicializar la categoría seleccionada
  var searchQuery = "".obs; // Inicializar la consulta de búsqueda
  var filteredEjercicios = <Ejercicio>[].obs;
  var ejercicio = Ejercicio(
    idEjercicio: 0,
    nombre: "",
    descripcion: "",
    idCategoria: 0,
  ).obs; // Inicializar el ejercicio

  var lastId;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEjercicios();
    await getCategorias();

    lastId = ejercicios.isNotEmpty ? ejercicios.last.idEjercicio : 0; // Obtener el último ID de ejercicio
    filterEjercicios();// Inicializar la lista filtrada con todos los ejercicios
  }

  Future<void> getEjercicios() async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios.getExercisesWithCategory();

    if (result.success) {
      ejercicios = result.data as List<Ejercicio>; // Asignar correctamente los datos a la rutina observable
      
    } else {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    }
    isLoading.value = false;
  }

  Future<void> getCategorias() async {
    isLoading.value = true;
    result = await _supabaseService.categorias.getCategories();

    if (result.success) {
      categorias.value = result.data as List<Categoria>; // Asignar correctamente los datos a la lista reactiva
    } else {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    }
    isLoading.value = false;
  }

  Future<void> addEjercicio() async{
    isLoading.value = true;
    ejercicio.value.idEjercicio = lastId + 1; // Asignar un nuevo ID al ejercicio
    ejercicio.value.categoria = categorias.firstWhere((categoria) => categoria.idCategoria == ejercicio.value.idCategoria); // Asignar la categoría al ejercicio
    result = await _supabaseService.ejercicios.addExercise(ejercicio.value);

    if (!result.success) {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    } else {
      ejercicios.add(ejercicio.value); 
      filteredEjercicios();// Agregar el nuevo ejercicio a la lista de ejercicios
      
      lastId++;
    }

    isLoading.value = false;
  }

  Future<void> deleteExercise(int idEjercicio) async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios.deleteExercise(idEjercicio);

    if (result.success) {
      ejercicios.removeWhere((ejercicio) => ejercicio.idEjercicio == idEjercicio); // Eliminar el ejercicio de la lista
      filteredEjercicios.removeWhere((ejercicio) => ejercicio.idEjercicio == idEjercicio); // Eliminar el ejercicio de la lista filtrada
    } else {
      Get.snackbar(
        "Error",
        result.errorMessage ?? "Unknown error",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red, // Fondo rojo
        colorText: Colors.white, // Texto blanco
      );
    }
    isLoading.value = false;
  }

  void filterEjercicios() {
    if (searchQuery.value.isEmpty && selctedCategoryId.value == 0) {
      filteredEjercicios.value = ejercicios; // Si no hay filtro, mostrar todos los ejercicios
    } 
    else if (searchQuery.value.isNotEmpty && selctedCategoryId.value == 0) {
      filteredEjercicios.value = ejercicios
          .where((ejercicio) => ejercicio.nombre.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    } 
    else if (searchQuery.value.isEmpty && selctedCategoryId.value != 0) {
      filteredEjercicios.value = ejercicios
          .where((ejercicio) => ejercicio.idCategoria == selctedCategoryId.value)
          .toList();
    } 
    else {
      filteredEjercicios.value = ejercicios
          .where((ejercicio) => ejercicio.nombre.toLowerCase().contains(searchQuery.value.toLowerCase()) 
                  && ejercicio.idCategoria == selctedCategoryId.value)
          .toList();
    }

    // Ordenar por el nombre de la categoría
    filteredEjercicios.sort((a, b) {
      final nombreCategoriaA = a.categoria?.nombre.toLowerCase() ?? '';
      final nombreCategoriaB = b.categoria?.nombre.toLowerCase() ?? '';
      return nombreCategoriaA.compareTo(nombreCategoriaB);
    });
  }
}