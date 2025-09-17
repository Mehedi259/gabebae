import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

/// =======================================================
/// OnBoarding1Screen
/// -------------------------------------------------------
/// - Responsive design (double.infinity for width)
/// - Uses assets via AssetGen
/// - Professional, compact, and scalable
/// =======================================================
class OnBoarding1Screen extends StatelessWidget {
  const OnBoarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// ============= Top Container (Image + Title) =============
          SizedBox(
            width: double.infinity,
            height: 276,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Splash style image
                SizedBox(
                  width: 190,
                  height: 160,
                  child: Assets.images.splash.image(fit: BoxFit.contain),
                ),

                const SizedBox(height: 20),

                /// Title Text
                const Text(
                  "Menu\nSidekick",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "EB Garamond",
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                    height: 1.0,
                    color: Color(0xFF1F2937), // #1F2937
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ============= Middle Container (Subtitle + Description) =============
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Subtitle with flower icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hey there, beautiful soul",
                      style: TextStyle(
                        fontFamily: "EB Garamond",
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        height: 1.25,
                        color: Color(0xFFE27B4F), // primary
                      ),
                    ),
                    const SizedBox(width: 8),
                    Assets.images.flower.image(
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Description text
                const Text(
                  "Welcome to Menu Sidekick!\n"
                      "Your pocket-friendly foodie guide\n"
                      "that makes eating out simple,\n"
                      "safe, and joyful.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF4B5563), // #4B5563
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// ============= Bottom Button =============
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: "Let’s Begin ✨",
                onTap: () => context.go(RoutePath.scanMenu.addBasePath),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
