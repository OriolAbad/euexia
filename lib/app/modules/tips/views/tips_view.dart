import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/tips/controllers/tips_controller.dart';

class TipsView extends StatelessWidget {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips'),
      ),
      body: GetBuilder<TipsController>(
        init: TipsController(),
        builder: (controller) {
          return FutureBuilder(
            future: controller.getTips(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child:  Text('Data loaded'),
                );
              }
            },
          );
        },
      ),
    );
  }
}