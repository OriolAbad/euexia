// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:euexia/app/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); //wait load env

  String supaUri = dotenv.get('SUPABASE_URL'); //get env key
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');

  Supabase supaProvider = await Supabase.initialize(
    url: supaUri,
    anonKey: supaAnon,
  );

  final authC = Get.put(AuthController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.SPLASH, // Cambia la ruta inicial al splash
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}