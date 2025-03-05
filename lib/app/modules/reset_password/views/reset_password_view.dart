import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/reset_password/controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

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
              // Password TextField
              TextField(
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              // Confirm Password TextField
              TextField(
                onChanged: (value) => controller.confirmPassword.value = value,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),
              // Reset Password Button
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.resetPassword();
                      },
                      child: const Text("Reset Password"),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
