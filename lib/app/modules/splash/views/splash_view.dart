import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:euexia/app/routes/app_pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Redirigir después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      final supaProvider = Supabase.instance.client;
      if (supaProvider.auth.currentUser == null) {
        Get.offNamed(Routes.LOGIN);
      } else {
        Get.offNamed(Routes.HOME);
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EUEXIA',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                SpinKitSpinningLines(
                  color: Colors.white,
                  size: 50.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
