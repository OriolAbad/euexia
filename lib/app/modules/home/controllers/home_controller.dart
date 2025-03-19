import 'package:get/get.dart';
import 'package:euexia/app/data/models/notes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controlador para gestionar los planes en la aplicación
class HomeController extends GetxController {
  // Lista reactiva que almacenará todos los planes
  RxList allNotes = List<Notes>.empty().obs;

  // Cliente de Supabase para interactuar con la base de datos
  SupabaseClient client = Supabase.instance.client;

  // Método para obtener todos los planes del usuario actual
  Future<void> getAllNotes() async {
    // Verificar si el usuario está autenticado
    final currentUser = client.auth.currentUser;
    if (currentUser == null) {
      // Manejar el caso en que el usuario no esté autenticado
      print("Usuario no autenticado");
      return;
    }

    // Se obtiene el ID del usuario desde la tabla "usuarios" filtrando por el UID de autenticación actual
    List<dynamic> res = await client
        .from("usuarios")
        .select("id")
        .match({"uid": currentUser.id});

    // Se extrae el primer resultado de la consulta como un mapa
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;

    // Se obtiene el ID del usuario
    int id = user["id"]; // Obtener el ID del usuario antes de recuperar los planes

    // Se obtienen todos los planes de la tabla "plans" que pertenecen a este usuario
    var notes = await client.from("plans").select().match(
      {"user_id": id}, // Filtrar los planes por el ID del usuario
    );

    // Convertir la lista obtenida en una lista de objetos Notes
    List<Notes> notesData = Notes.fromJsonList((notes as List));

    // Actualizar la lista reactiva con los datos obtenidos
    allNotes(notesData);
    allNotes.refresh(); // Refrescar la lista para reflejar los cambios en la UI
  }

  // Método para eliminar un plan por su ID
  Future<void> deleteNote(int id) async {
    await client.from("plans").delete().match({
      "id": id, // Buscar el plan por su ID y eliminarlo
    });

    // Volver a obtener la lista de planes después de la eliminación
    getAllNotes();
  }
}