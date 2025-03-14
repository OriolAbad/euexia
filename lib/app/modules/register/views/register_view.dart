import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_coloured_buttons/gradient_coloured_buttons.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Fondo negro grafito
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF212121),
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.nameC,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.person, color: Colors.black),
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
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.apellido1C,
                      decoration: InputDecoration(
                        hintText: "Apellido1",
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.badge, color: Colors.black),
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
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.apellido2C,
                      decoration: InputDecoration(
                        hintText: "Apellido2",
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.badge, color: Colors.black),
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
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.userNameC,
                      decoration: InputDecoration(
                        hintText: "User Name",
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.account_circle, color: Colors.black),
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
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.emailC,
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
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.locationC,
                      decoration: InputDecoration(
                        hintText: "Location",
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.location_on, color: Colors.black),
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
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
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
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => controller.isHidden.toggle(),
                        icon: controller.isHidden.isTrue
                            ? const Icon(Icons.remove_red_eye,
                                color: Colors.black)
                            : const Icon(Icons.remove_red_eye_outlined,
                                color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  )),
              const SizedBox(height: 30),
              Obx(() => GradientButton(
                    text: controller.isLoading.isFalse
                        ? "REGISTER"
                        : "Loading...",
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    gradientColors: const [
                      Color.fromARGB(255, 225, 117, 15),
                      Color(0xFFB71C1C)
                    ],
                    width: double.infinity,
                    height: 50,
                    borderRadius: 10.0,
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.signUp();
                      }
                    },
                  )),
              const SizedBox(height: 10),
              GradientButton(
                text: "BACK TO LOGIN",
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                gradientColors: const [
                  Color.fromARGB(255, 225, 117, 15),
                  Color(0xFFB71C1C)
                ],
                width: double.infinity,
                height: 50,
                borderRadius: 10.0,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}