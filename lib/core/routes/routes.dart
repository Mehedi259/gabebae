// lib/core/routes/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/ProfileAndSettings/about_us.dart';
import '../../presentation/screens/ProfileAndSettings/account_settings.dart';
import '../../presentation/screens/ProfileAndSettings/edit_profile.dart';
import '../../presentation/screens/ProfileAndSettings/help_and_support.dart';
import '../../presentation/screens/ProfileAndSettings/my_profile.dart';
import '../../presentation/screens/ProfileAndSettings/privacy_policy.dart';
import '../../presentation/screens/ProfileAndSettings/switch_profile.dart';
import '../../presentation/screens/ProfileAndSettings/terms_and_condition.dart';
import '../../presentation/screens/authentication/forget_password.dart';
import '../../presentation/screens/authentication/privacy_policy.dart';
import '../../presentation/screens/authentication/terms_condition.dart';
import '../../presentation/screens/authentication/verify_code.dart';
import '../../presentation/screens/chatbot/ask_chat_bot.dart';
import '../../presentation/screens/home/activity.dart';
import '../../presentation/screens/home/home.dart';
import '../../presentation/screens/onbording/onbording1.dart';
import '../../presentation/screens/onbording/onbording2.dart';
import '../../presentation/screens/onbording/splash_screen.dart';
import '../../presentation/screens/profileSetup/profile_setup1.dart';
import '../../presentation/screens/profileSetup/profile_setup2.dart';
import '../../presentation/screens/profileSetup/profile_setup3.dart';
import '../../presentation/screens/profileSetup/profile_setup4.dart';
import '../../presentation/screens/profileSetup/profile_setup5.dart';
import '../../presentation/screens/profileSetup/profile_setup6.dart';
import '../../presentation/screens/profileSetup/profile_setup7.dart';
import '../../presentation/screens/profileSetupUpdate/profile_setup1.dart';
import '../../presentation/screens/profileSetupUpdate/profile_setup2.dart';
import '../../presentation/screens/profileSetupUpdate/profile_setup3.dart';
import '../../presentation/screens/profileSetupUpdate/profile_setup4.dart';
import '../../presentation/screens/profileSetupUpdate/profile_setup5.dart';
import '../../presentation/screens/scanMenu/scan_menu.dart';
import '../../presentation/screens/scanMenu/scan_result_all.dart';
import '../../presentation/screens/scanMenu/scan_result_build_my_plate.dart';
import '../../presentation/screens/scanMenu/scan_result_ordering_tips.dart';
import '../../presentation/screens/scanMenu/scan_result_save_your_meal.dart';
import '../../presentation/screens/scanMenu/my_qr_code.dart';
import '../../presentation/screens/subscription/subscription.dart';
import 'route_observer.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
    initialLocation: RoutePath.splashScreen.addBasePath,
    debugLogDiagnostics: true,
    routes: [

      /// Onboarding
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RoutePath.onBoarding1,
        path: RoutePath.onBoarding1.addBasePath,
        builder: (context, state) => const OnBoarding1Screen(),
      ),
      GoRoute(
        name: RoutePath.onBoarding2,
        path: RoutePath.onBoarding2.addBasePath,
        builder: (context, state) => const OnBoarding2Screen(),
      ),

      /// Authentication
      GoRoute(
        name: RoutePath.enterEmail,
        path: RoutePath.enterEmail.addBasePath,
        builder: (context, state) => const EnterEmailScreen(),
      ),
      GoRoute(
        name: RoutePath.verifyCode,
        path: RoutePath.verifyCode.addBasePath,
        builder: (context, state) {
          // Get email from extra parameter
          final email = state.extra as String?;
          return OtpScreen(email: email);
        },
      ),
      GoRoute(
        name: RoutePath.privacyPolicyAuth,
        path: RoutePath.privacyPolicyAuth.addBasePath,
        builder: (context, state) => const PrivacyPolicyScreenAuth(),
      ),
      GoRoute(
        name: RoutePath.termsAndConditionAuth,
        path: RoutePath.termsAndConditionAuth.addBasePath,
        builder: (context, state) => const TermsOfServiceScreenAuth(),
      ),


      /// Profile Setup
      GoRoute(
        name: RoutePath.profileSetup1,
        path: RoutePath.profileSetup1.addBasePath,
        builder: (context, state) => const ProfileSetup1Screen(),
      ),
      GoRoute(
        name: RoutePath.profileSetup2,
        path: RoutePath.profileSetup2.addBasePath,
        builder: (context, state) => const ProfileSetup2Screen(),
      ),
      GoRoute(
        name: RoutePath.profileSetup3,
        path: RoutePath.profileSetup3.addBasePath,
        builder: (context, state) => const ProfileSetup3Screen(),
      ),
      GoRoute(
        name: RoutePath.profileSetup4,
        path: RoutePath.profileSetup4.addBasePath,
        builder: (context, state) => const ProfileSetup4Screen(),
      ),
      GoRoute(
        name: RoutePath.profileSetup5,
        path: RoutePath.profileSetup5.addBasePath,
        builder: (context, state) => const ProfileSetup5Screen(),
      ),
      GoRoute(
        name: RoutePath.profileSetup6,
        path: RoutePath.profileSetup6.addBasePath,
        builder: (context, state) => const ProfileSetup6Screen(),
      ),
      GoRoute(
        name: RoutePath.privacyPolicyPs,
        path: RoutePath.privacyPolicyPs.addBasePath,
        builder: (context, state) => const PrivacyPolicyScreenPs(),
      ),


      /// Profile Setup Update
      GoRoute(
        name: RoutePath.profileSetup1Update,
        path: RoutePath.profileSetup1Update.addBasePath,
        builder: (context, state) => const ProfileSetup1ScreenUpdate(),
      ),
      GoRoute(
        name: RoutePath.profileSetup2Update,
        path: RoutePath.profileSetup2Update.addBasePath,
        builder: (context, state) => const ProfileSetup2ScreenUpdate(),
      ),
      GoRoute(
        name: RoutePath.profileSetup3Update,
        path: RoutePath.profileSetup3Update.addBasePath,
        builder: (context, state) => const ProfileSetup3ScreenUpdate(),
      ),
      GoRoute(
        name: RoutePath.profileSetup4Update,
        path: RoutePath.profileSetup4Update.addBasePath,
        builder: (context, state) => const ProfileSetup4ScreenUpdate(),
      ),
      GoRoute(
        name: RoutePath.profileSetup5Update,
        path: RoutePath.profileSetup5Update.addBasePath,
        builder: (context, state) => const ProfileSetup5ScreenUpdate(),
      ),

      /// Home
      GoRoute(
        name: RoutePath.home,
        path: RoutePath.home.addBasePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: RoutePath.favourites,
        path: RoutePath.favourites.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.activity,
        path: RoutePath.activity.addBasePath,
        builder: (context, state) => const YourActivityScreen(),
      ),

      /// Scan Menu
      GoRoute(
        name: RoutePath.scanMenu,
        path: RoutePath.scanMenu.addBasePath,
        builder: (context, state) => const ScanMenuScreen(),
      ),
      GoRoute(
        name: RoutePath.body,
        path: RoutePath.body.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.scanResultAll,
        path: RoutePath.scanResultAll.addBasePath,
        builder: (context, state) => const MealResultsScreen(),
      ),
      GoRoute(
        name: RoutePath.scanResultSafe,
        path: RoutePath.scanResultSafe.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.scanResultModify,
        path: RoutePath.scanResultModify.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.scanResultAvoid,
        path: RoutePath.scanResultAvoid.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.scanResultBuildMyPlate,
        path: RoutePath.scanResultBuildMyPlate.addBasePath,
        builder: (context, state) => const BuildMyPlateScreen(),
      ),
      GoRoute(
        name: RoutePath.scanResultOrderingTips,
        path: RoutePath.scanResultOrderingTips.addBasePath,
        builder: (context, state) => const OrderingTipsScreen(),
      ),
      GoRoute(
        name: RoutePath.scanResultSaveYourMeals,
        path: RoutePath.scanResultSaveYourMeals.addBasePath,
        builder: (context, state) => const SaveMealScreen(),
      ),
      GoRoute(
        name: RoutePath.myQrCode,
        path: RoutePath.myQrCode.addBasePath,
        builder: (context, state) => const AlaCarteQRScreen(),
      ),

      /// Chat Bot
      GoRoute(
        name: RoutePath.askChatBot,
        path: RoutePath.askChatBot.addBasePath,
        builder: (context, state) => const MenuSidekickChatScreen(),
      ),


      /// Profile & Settings
      GoRoute(
        name: RoutePath.myProfile,
        path: RoutePath.myProfile.addBasePath,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        name: RoutePath.switchProfile,
        path: RoutePath.switchProfile.addBasePath,
        builder: (context, state) => const SwitchProfileScreen(),
      ),
      GoRoute(
        name: RoutePath.editProfile,
        path: RoutePath.editProfile.addBasePath,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        name: RoutePath.notification,
        path: RoutePath.notification.addBasePath,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        name: RoutePath.helpAndSupport,
        path: RoutePath.helpAndSupport.addBasePath,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        name: RoutePath.accountSettings,
        path: RoutePath.accountSettings.addBasePath,
        builder: (context, state) => const AccountSettingsScreen(),
      ),

      GoRoute(
        name: RoutePath.termsAndCondition,
        path: RoutePath.termsAndCondition.addBasePath,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        name: RoutePath.privacyPolicy,
        path: RoutePath.privacyPolicy.addBasePath,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        name: RoutePath.aboutUs,
        path: RoutePath.aboutUs.addBasePath,
        builder: (context, state) => const AboutUsScreen(),
      ),

      /// Subscription
      GoRoute(
        name: RoutePath.subscription,
        path: RoutePath.subscription.addBasePath,
        builder: (context, state) => const SubscriptionsScreen(),
      ),
    ],
    observers: [routeObserver],
  );

  static GoRouter get route => initRoute;
}

// Extension for base path
extension BasePathExtension on String {
  String get addBasePath => '/$this';
}