import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditNoteController extends GetxController {
  // Estado observable para indicar si la operación está en curso (cargando)
  RxBool isLoading = false.obs;

  // Estado observable para controlar si un campo debe permanecer oculto (posiblemente para contraseñas u otros campos)
  RxBool isHidden = true.obs;

  // Controladores para los campos de texto del título y la descripción del plan
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  // Estado observable para manejar la fecha del plan
  Rx<DateTime?> dateC = Rx<DateTime?>(null);

  // Cliente de Supabase para interactuar con la base de datos
  SupabaseClient client = Supabase.instance.client;

  // Método para seleccionar una fecha usando el selector de fecha de Flutter
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateC.value ?? DateTime.now(), // Si no hay fecha seleccionada, usa la actual
      firstDate: DateTime(2000), // Fecha mínima permitida
      lastDate: DateTime(2100),  // Fecha máxima permitida
    );

    if (picked != null) {
      dateC.value = picked; // Asigna la fecha seleccionada
    }
  }

  // Método para editar un plan existente en la base de datos
  Future<bool> editNote(int id) async {
    // Verifica que los campos obligatorios no estén vacíos
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty && dateC.value != null) {
      isLoading.value = true; // Indica que la operación está en curso

      // Actualiza el plan en la base de datos usando Supabase
      await client
          .from("plans")
          .update({
            "title": titleC.text,
            "description": descC.text,
            "date": dateC.value!.toIso8601String(), // Guarda la fecha en formato ISO
          })
          .match({"id": id}); // Filtra por el ID del plan a editar

      return true; // Indica que la edición fue exitosa
    } else {
      return false; // Indica que la operación falló debido a campos vacíos
    }
  }
}
