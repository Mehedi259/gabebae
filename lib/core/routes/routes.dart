import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_observer.dart';
import 'route_path.dart';


class AppRouter {
  static final GoRouter initRoute = GoRouter(
    /// ==================== Initial Route ====================

    initialLocation: RoutePath.splashScreen.addBasePath,

    debugLogDiagnostics: true,
    routes: [

      /// ==================== Splash ====================
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        builder: (context, state) => const Placeholder(), // SplashScreen()
      ),

      /// ==================== OnBoarding ====================
      GoRoute(
        name: RoutePath.onBoarding1,
        path: RoutePath.onBoarding1.addBasePath,
        builder: (context, state) => const Placeholder(), // OnBoarding1Screen()
      ),
      GoRoute(
        name: RoutePath.onBoarding2,
        path: RoutePath.onBoarding2.addBasePath,
        builder: (context, state) => const Placeholder(), // OnBoarding2Screen()
      ),

      /// ==================== Auth ====================
      GoRoute(
        name: RoutePath.enterEmail,
        path: RoutePath.enterEmail.addBasePath,
        builder: (context, state) => const Placeholder(), // EnterEmailScreen()
      ),
      GoRoute(
        name: RoutePath.verifyCode,
        path: RoutePath.verifyCode.addBasePath,
        builder: (context, state) => const Placeholder(), // VerifyCodeScreen()
      ),

      /// ==================== Profile Setup ====================
      GoRoute(
        name: RoutePath.profileSetup1,
        path: RoutePath.profileSetup1.addBasePath,
        builder: (context, state) => const Placeholder(), // ProfileSetup1Screen()
      ),
      GoRoute(
        name: RoutePath.profileSetup2,
        path: RoutePath.profileSetup2.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.profileSetup3,
        path: RoutePath.profileSetup3.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),


      /// ==================== Home ====================
      GoRoute(
        name: RoutePath.home,
        path: RoutePath.home.addBasePath,
        builder: (context, state) => const Placeholder(), // HomeScreen()
      ),
      GoRoute(
        name: RoutePath.favourites,
        path: RoutePath.favourites.addBasePath,
        builder: (context, state) => const Placeholder(), // FavouritesScreen()
      ),
      GoRoute(
        name: RoutePath.activity,
        path: RoutePath.activity.addBasePath,
        builder: (context, state) => const Placeholder(), // ActivityScreen()
      ),

      /// ==================== Scan Menu ====================
      GoRoute(
        name: RoutePath.scanMenu,
        path: RoutePath.scanMenu.addBasePath,
        builder: (context, state) => const Placeholder(), // ScanMenuScreen()
      ),
      GoRoute(
        name: RoutePath.scanResultAll,
        path: RoutePath.scanResultAll.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),


      /// ==================== Chat Bot ====================
      GoRoute(
        name: RoutePath.askChatBot,
        path: RoutePath.askChatBot.addBasePath,
        builder: (context, state) => const Placeholder(), // AskChatBotScreen()
      ),

      /// ==================== Profile & Settings ====================
      GoRoute(
        name: RoutePath.myProfile,
        path: RoutePath.myProfile.addBasePath,
        builder: (context, state) => const Placeholder(), // MyProfileScreen()
      ),
      GoRoute(
        name: RoutePath.editProfile,
        path: RoutePath.editProfile.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.accountSettings,
        path: RoutePath.accountSettings.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.changePassword,
        path: RoutePath.changePassword.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),


      /// ==================== Subscription ====================
      GoRoute(
        name: RoutePath.subscription,
        path: RoutePath.subscription.addBasePath,
        builder: (context, state) => const Placeholder(), // SubscriptionScreen()
      ),
    ],
    observers: [routeObserver],
  );

  static GoRouter get route => initRoute;
}

/// ==================== Extension ====================
/// Add base '/' before every path automatically
extension BasePathExtension on String {
  String get addBasePath => '/$this';
}
