import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseService client = SupabaseService();
  custom_response.Response response = custom_response.Response(success: false);
  

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool?> login() async {
    bool? result;

    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;

      // response = await client.login(emailC.text, passwordC.text);
      if (response.success) {
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Login success",
            middleText: "Will be redirect to Home Page",
            backgroundColor: Colors.green);
        
        result = true;
      } else {
        isLoading.value = false;
        Get.snackbar("ERROR", response.errorMessage ?? "An unknown error occurred");
        result = false;
      }
      
      isLoading.value = false;
      return result;
    }
    return result;
  }
}