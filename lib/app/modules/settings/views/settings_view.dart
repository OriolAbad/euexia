import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_coloured_buttons/gradient_coloured_buttons.dart';
import 'package:euexia/app/controllers/auth_controller.dart';
import 'package:euexia/app/routes/app_pages.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Fondo negro grafito
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.logout();
              await authC.resetTimer();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
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
                  Center(
                    child: Text(
                      controller.emailC.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    controller: controller.nombreusuarioC2,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "UserName",
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
                  const SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    controller: controller.passwordC,
                    textInputAction: TextInputAction.done,
                    obscureText: controller.isHidden.value,
                    decoration: InputDecoration(
                      hintText: "New password",
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
                  ),
                  const SizedBox(height: 30),
                  Obx(() => GradientButton(
                        text: controller.isLoading.isFalse ? "UPDATE PROFILE" : "Loading...",
                        textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                        gradientColors: const [
                          Color.fromARGB(255, 225, 117, 15),
                          Color(0xFFB71C1C)
                        ],
                        width: double.infinity,
                        height: 50,
                        borderRadius: 10.0,
                        onPressed: () async {
                          if (controller.isLoading.isFalse) {
                            if (controller.nombreusuarioC.text == controller.nombreusuarioC2.text &&
                                controller.passwordC.text.isEmpty) {
                              // Check if user have same name and not want to change password but they click the button
                              Get.snackbar("Info", "There is no data to update",
                                  borderWidth: 1,
                                  borderColor: Colors.white,
                                  barBlur: 100);
                              return;
                            }
                            await controller.updateProfile();
                            if (controller.passwordC.text.isNotEmpty &&
                                controller.passwordC.text.length >= 6) {
                              await controller.logout();
                              await authC.resetTimer();
                              Get.offAllNamed(Routes.LOGIN);
                            }
                          }
                        },
                      )),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}