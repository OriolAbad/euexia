import 'package:euexia/app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/data/help/response.dart' as custom_response;
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  late custom_response.Response result; 
  Supabase supabase = Supabase.instance;
  SupabaseService client = SupabaseService();
  custom_response.Response response = custom_response.Response(success: false);

  var isHoveringForgotPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /*Future<void> signInWithGoogle() async {
    final supabase = Supabase.instance.client;

    if (kIsWeb) {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://fewllovypiblimiutsji.supabase.co/auth/v1/callback',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } else {
      const webClientId =
          '558314433035-7vvapu23aq5gk7j2utct0kqqocvu814p.apps.googleusercontent.com';
      const iosClientId =
          '558314433035-qrjfc6mo41hu4qnu05vpcp4mlevbsk25.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'No Access Token or ID Token found.';
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    }
  }*/

  Future<bool?> login() async {
    bool? result;

    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;

      response = await client.usuarios.login(emailC.text, passwordC.text);
      if (response.success) {
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Login success",
            middleText: "Will be redirect to Home Page",
            backgroundColor: Colors.green);

        result = true;
      } else {
        isLoading.value = false;
        Get.snackbar(
            "ERROR", response.errorMessage ?? "An unknown error occurred");
        result = false;
      }

      isLoading.value = false;
      return result;
    }
    return result;
  }
}
