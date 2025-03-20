import 'package:euexia/app/data/models/usuarios.dart';
import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController apellido1 = TextEditingController();
  TextEditingController apellido2 = TextEditingController();
  TextEditingController nombreusuario = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController location = TextEditingController();
  
  final SupabaseService _supabaseService = SupabaseService();
  late custom_response.Response result; 

  Future<void> signUp() async {
    if (nameC.text.isNotEmpty && 
        apellido1.text.isNotEmpty && 
        emailC.text.isNotEmpty && 
        passwordC.text.isNotEmpty &&
        nombreusuario.text.isNotEmpty &&
        location.text.isNotEmpty) {
      
      isLoading.value = true;

      try {
        Usuario usuario = Usuario(
          nombre: nameC.text,
          apellido1: apellido1.text,
          apellido2: apellido2.text,
          email: emailC.text,
          nombreUsuario: nombreusuario.text,
          created_at: DateTime.now(),
          location: location.text
        );

        // result = await _supabaseService.usuarios.addUser(usuario, passwordC.text);
        isLoading.value = false;

        if(result.success){
          Get.defaultDialog(
                      barrierDismissible: false,
                      title: "Registration success",
                      middleText: "Please confirm email: ${usuario.email}",
                      actions: [
                        OutlinedButton(
                            onPressed: () {
                              Get.back(); //close dialog
                              Get.back(); //back to login page
                            },
                            child: const Text("OK"))
                      ]);
        }
        else{
          Get.snackbar("ERROR", result.errorMessage.toString());
        }
        
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Email, password and name are required");
    }
  }
}
