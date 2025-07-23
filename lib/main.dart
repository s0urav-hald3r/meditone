import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:meditone/screens/settings_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/controllers/music_controller.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/screens/main_screen.dart';
import 'package:meditone/screens/premium_screen.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/utils/app_constant.dart';
import 'package:meditone/utils/local_storage.dart';

// Configure RevenueCat SDK
Future<void> _configureRevenueCat() async {
  try {
    // Enable debug logs in development
    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    PurchasesConfiguration configuration;

    if (Platform.isIOS) {
      configuration = PurchasesConfiguration(RevenueCatConfig.appleApiKey);
    } else {
      configuration = PurchasesConfiguration(RevenueCatConfig.googleApiKey);
    }

    await Purchases.configure(configuration);
  } catch (e) {
    // Handle configuration error silently
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize local storage
  await LocalStorage.init();

  // Configure RevenueCat
  await _configureRevenueCat();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // whenever your initialization is completed, remove the splash screen:
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class DataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnimationsController());
    Get.lazyPut(() => MusicController());
    Get.lazyPut(() => MeditationController());
    Get.lazyPut(() => PremiumController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Meditone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainScreen(),
          binding: DataBinding(),
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsScreen(),
          binding: DataBinding(),
        ),
        GetPage(
          name: '/premium',
          page: () => const PremiumScreen(),
          binding: DataBinding(),
        ),
      ],
    );
  }
}
