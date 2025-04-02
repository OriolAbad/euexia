import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/categorias.dart';
import 'package:euexia/app/data/models/ejercicios.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  ExercisesController([this.trainingId]); // Hacer que el parámetro sea opcional

  final int? trainingId; // Declarar el trainingId como nullable
  
  final _supabaseService = SupabaseService();
  custom_response.Response result = custom_response.Response(success: false);

  var isLoading = false.obs;
  late List<Ejercicio> ejercicios;
  var categorias = <Categoria>[].obs; // Inicializar como lista reactiva vacía

  RxInt selctedCategoryId = 0.obs; // Inicializar la categoría seleccionada
  RxString searchQuery = "".obs; // Inicializar la consulta de búsqueda
  var filteredEjercicios = <Ejercicio>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEjercicios();
    await getCategorias();
  }

  Future<void> getEjercicios() async {
    isLoading.value = true;
    result = await _supabaseService.ejercicios.getExercisesWithCategory();

    if (result.success) {
      ejercicios = result.data as List<Ejercicio>; // Asignar correctamente los datos a la rutina observable
      filteredEjercicios.value = ejercicios; // Inicializar la lista filtrada con todos los ejercicios
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
    isLoading.value = false;
  }

  Future<void> getCategorias() async {
    isLoading.value = true;
    result = await _supabaseService.categorias.getCategories();

    if (result.success) {
      categorias.value = result.data as List<Categoria>; // Asignar correctamente los datos a la lista reactiva
    } else {
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
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
  }
}