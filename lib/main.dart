import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/controllers/music_controller.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/screens/main_screen.dart';
import 'package:meditone/screens/premium_screen.dart';
import 'package:meditone/themes/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize controllers
  Get.lazyPut(() => AnimationsController());
  Get.lazyPut(() => MusicController());
  Get.lazyPut(() => MeditationController());
  Get.lazyPut(() => PremiumController());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // whenever your initialization is completed, remove the splash screen:
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final animationsController = Get.find<AnimationsController>();
    final musicController = Get.find<MusicController>();
    final meditationController = Get.find<MeditationController>();

    // Set initial animation and music

    if (animationsController.animations.isNotEmpty) {
      meditationController.setAnimation(animationsController.animations[0]);
    }

    if (musicController.musicTracks.isNotEmpty) {
      meditationController.setMusic(musicController.musicTracks[0]);
    }

    return GetMaterialApp(
      title: 'Meditone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/premium', page: () => PremiumScreen()),
      ],
    );
  }
}
