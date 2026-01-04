// // lib/main.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:device_preview/device_preview.dart';
//
// import 'core/controllers/language_controller.dart';
// import 'core/routes/routes.dart';
// import 'l10n/app_localizations.dart';
// import 'utils/app_colors/app_colors.dart';
//
// late final List<CameraDescription> cameras;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//   cameras = await availableCameras();
//
//   Get.put(LanguageController(), permanent: true);
//
//   runApp(
//     DevicePreview(
//       enabled: true, // turn off in release: !kReleaseMode
//       builder: (_) => const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final languageController = Get.find<LanguageController>();
//
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, __) {
//         return GetMaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           title: "MenuSideKick",
//
//           // Required for DevicePreview
//           useInheritedMediaQuery: true,
//           builder: DevicePreview.appBuilder,
//           locale: DevicePreview.locale(context) ?? languageController.locale.value,
//
//           // Listen to language changes (GetX)
//           localeListResolutionCallback: (_, __) =>
//           languageController.locale.value,
//
//           // Localization delegates
//           localizationsDelegates: const [
//             AppLocalizations.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//
//           supportedLocales: const [
//             Locale('en'),
//             Locale('es'),
//             Locale('fr'),
//           ],
//
//           theme: ThemeData(
//             scaffoldBackgroundColor: AppColors.backgroundColor,
//             useMaterial3: true,
//           ),
//
//           // GoRouter
//           routeInformationParser: AppRouter.route.routeInformationParser,
//           routerDelegate: AppRouter.route.routerDelegate,
//           routeInformationProvider: AppRouter.route.routeInformationProvider,
//         );
//       },
//     );
//   }
// }
//

//lib/main.dart
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

late final List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  cameras = await availableCameras();


  Get.put(LanguageController(), permanent: true);

  runApp(const MyApp());
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
          title: "MenuSideKick",

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

