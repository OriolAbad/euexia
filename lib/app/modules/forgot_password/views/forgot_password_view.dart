import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:gradient_coloured_buttons/gradient_coloured_buttons.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Fondo oscuro
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
        title: const Text("Recuperar Contraseña"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Recuperar Contraseña',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/Logo_color.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // TextField para email
              GetBuilder<ForgotPasswordController>(
                builder: (_) => TextField(
                  onChanged: (value) => controller.email.value = value,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de enviar
              GradientButton(
                text:
                    controller.isLoading.value ? "Enviando..." : "Enviar Email",
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                gradientColors: const [Color(0xFFE1750F), Color(0xFFB71C1C)],
                width: double.infinity,
                height: 50,
                borderRadius: 10.0,
                onPressed: controller.isLoading.value
                    ? () {}
                    : () => controller.sendPasswordResetEmail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
