import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/reset_password/controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
        title: const Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Code TextField
              TextField(
                controller: codeController,
                onChanged: (value) => controller.code.value = value,
                decoration: _inputDecoration("Code"),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 15),

              // Password TextField
              TextField(
                controller: passwordController,
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
                decoration: _inputDecoration("New Password"),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 15),

              // Confirm Password TextField
              TextField(
                controller: confirmPasswordController,
                onChanged: (value) => controller.confirmPassword.value = value,
                obscureText: true,
                decoration: _inputDecoration("Confirm Password"),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),

              // Reset Password Button
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.resetPassword();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color personalizado
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Reset Password", style: TextStyle(fontSize: 18)),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
