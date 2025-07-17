import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/controllers/music_controller.dart';
import 'package:meditone/screens/main_screen.dart';
import 'package:meditone/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final animationsController = Get.put(AnimationsController());
    final musicController = Get.put(MusicController());
    final meditationController = Get.put(MeditationController());

    // Set initial animation and music
    Future.delayed(const Duration(milliseconds: 100), () {
      if (animationsController.animations.isNotEmpty) {
        meditationController.setAnimation(animationsController.animations[0]);
      }

      if (musicController.musicTracks.isNotEmpty) {
        meditationController.setMusic(musicController.musicTracks[0]);
      }
    });

    return GetMaterialApp(
      title: 'Meditone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
