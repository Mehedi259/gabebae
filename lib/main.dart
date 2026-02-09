// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/controllers/language_controller.dart';
import 'core/routes/routes.dart';
import 'l10n/app_localizations.dart';
import 'utils/app_colors/app_colors.dart';

// Make this nullable and initialize to empty list
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Wrap everything in error handling
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set system UI mode
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Initialize cameras with error handling
    try {
      cameras = await availableCameras();
      debugPrint('✅ Successfully initialized ${cameras.length} camera(s)');
    } catch (e, stackTrace) {
      debugPrint('❌ Camera initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue with empty cameras list - app will handle this gracefully
      cameras = [];
    }

    // Initialize language controller
    Get.put(LanguageController(), permanent: true);

    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('❌ Fatal error in main zone: $error');
    debugPrint('Stack trace: $stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return Obx(() => GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "Menu SideKick",

          /// Localization setup
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('fr'),
          ],
          locale: languageController.locale.value,

          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            useMaterial3: true,
          ),

          routeInformationParser: AppRouter.route.routeInformationParser,
          routerDelegate: AppRouter.route.routerDelegate,
          routeInformationProvider: AppRouter.route.routeInformationProvider,
        ));
      },
    );
  }
}