import 'dart:async';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds
    Timer(const Duration(seconds: 2), () {
      context.go(RoutePath.onBoarding1.addBasePath); // GoRouter navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
