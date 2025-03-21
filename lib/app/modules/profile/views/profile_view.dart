// lib/views/profile_view.dart
import 'package:euexia/app/modules/stats/views/stats_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:euexia/app/modules/account/views/account_view.dart';
import 'package:euexia/app/modules/gallery/views/gallery_view.dart';
import 'package:euexia/app/modules/home/views/home_view.dart'; 

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column( 
        children: [
          Stack(
            children: [
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/gym_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.off(() => HomeView()); 
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Obx(() => Text(
                  "Hi ${controller.username}!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildButton("Stats", () => Get.to(() => StatsView())),
          _buildButton("Gallery", () => Get.to(() => GalleryView())),
          _buildButton("Account", () => Get.to(() => AccountView())),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("Log out"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
