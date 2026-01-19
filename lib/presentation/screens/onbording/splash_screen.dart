// lib/presentation/screens/onbording/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/storage/storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is logged in
    final isLoggedIn = await StorageHelper.isLoggedIn();

    if (isLoggedIn) {
      // User has access token, navigate to home
      context.go(RoutePath.home.addBasePath);
    } else {
      // User is not logged in, navigate to onboarding
      context.go(RoutePath.onBoarding1.addBasePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SizedBox(
          width: 256,
          height: 256,
          child: Assets.images.splash.image(
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}