import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/controllers/auth_controller.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gradient_coloured_buttons/gradient_coloured_buttons.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Fondo negro grafito
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF212121), // Rojo intenso
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Euexia',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/Logo_color.png',
                height: 100,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: controller.emailC,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.black), // Texto negro
                  prefixIcon: const Icon(Icons.email, color: Colors.black), // Icono
                  filled: true,
                  fillColor: Colors.white, // Fondo blanco
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white), // Borde blanco
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white, width: 2), // Borde blanco al enfocar
                  ),
                ),
                style: const TextStyle(color: Colors.black), // Texto negro
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                    controller: controller.passwordC,
                    obscureText: controller.isHidden.value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => controller.isHidden.toggle(),
                        icon: controller.isHidden.isTrue
                            ? const Icon(Icons.remove_red_eye, color: Colors.black)
                            : const Icon(Icons.remove_red_eye_outlined, color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  )),
              const SizedBox(height: 30),
              Obx(() => GradientButton(
                    text: controller.isLoading.isFalse ? "SIGN IN" : "Loading...",
                    textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    gradientColors: const [Color.fromARGB(255, 225, 117, 15), Color(0xFFB71C1C)],
                    width: double.infinity,
                    height: 50,
                    borderRadius: 10.0,
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        bool? cekAutoLogout = await controller.login();
                        if (cekAutoLogout == true) {
                          await authC.autoLogout();
                          Get.offAllNamed(Routes.HOME);
                        }
                      }
                    },
                  )),
              const SizedBox(height: 10),
              GradientButton(
                text: "REGISTER",
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                gradientColors: const [Color.fromARGB(255, 225, 117, 15), Color(0xFFB71C1C)],
                width: double.infinity,
                height: 50,
                borderRadius: 10.0,
                onPressed: () => Get.toNamed(Routes.REGISTER),
              ),
              const SizedBox(height: 20),
              SignInButton(
                Buttons.google,
                onPressed: () async {
                  try {
                    final supabase = Supabase.instance.client;
                    final res = await supabase.auth.signInWithOAuth(
                      Provider.google,
                      redirectTo: 'https://ovfxbzqxcobozjpukzfo.supabase.co/auth/v1/callback',
                    );
                    if (res) {
                      Get.offNamed(Routes.HOME);
                    } else {
                      print('Error al iniciar sesión con Google');
                    }
                  } catch (error) {
                    print('Error de autenticación: $error');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla de recuperación de contraseña
                    //Get.toNamed(Routes.FORGOT_PASSWORD);
                  },
                  child: const Text(
                    '¿Has olvidado tu contraseña?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}