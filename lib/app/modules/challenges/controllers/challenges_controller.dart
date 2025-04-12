import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:euexia/app/data/models/retos.dart';
import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/data/models/usuarios_retos.dart';
import 'package:euexia/app/services/service.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController{
  final _supabaseService = SupabaseService();

  var isLoading = false.obs;
  var retos = [].obs;
  late int idUsuarioLogged = 0;

  custom_response.Response result = custom_response.Response(success: false);

  @override

  Future<void> onInit() async {
    super.onInit();

    await getLoggedUser();
    await getRetosOfUser();
  }

  Future<void> getLoggedUser() async{
    isLoading.value = true;
    result = await _supabaseService.usuarios.getLoggedInUser();

    if(result.success){
      Usuario loggedUser = result.data as Usuario;
      idUsuarioLogged = loggedUser.idUsuario!;
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }

    isLoading.value = false;  
  }

  Future<void> getRetosOfUser() async{
    isLoading.value = true;
    result = await _supabaseService.usuarios_retos.getUsuariosRetosByIdWithRetos(idUsuarioLogged);

    if(result.success){
      retos.assignAll(result.data as Iterable<UsuarioReto>); // Asignar correctamente los datos a la lista observable
    }
    else{
      Get.snackbar("Error", result.errorMessage ?? "Unknown error");
    }
 
    isLoading.value = false;  
  }

}