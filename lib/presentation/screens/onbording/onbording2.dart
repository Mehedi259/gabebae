import 'package:flutter/material.dart';
import 'package:gabebae/presentation/screens/onbording/splashScreen.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';


/// =======================================================
/// OnBoarding2Screen
/// -------------------------------------------------------
/// - Progress indicator (dots)
/// - Heading "How It Works ✨"
/// - Illustration image
/// - Reusable custom button
/// =======================================================
class OnBoarding2Screen extends StatelessWidget {
  const OnBoarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// ================= Progress Indicator =================
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Dot 1 (Inactive)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD1D5DB),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                  ),

                  /// Dot 2 (Active)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B35),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ================= Title Text =================
            const Text(
              "How It Works ✨",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 32 / 24,
                color: Color(0xFF0F5132), // #0F5132
              ),
            ),

            const SizedBox(height: 24),

            /// ================= Illustration Image =================
            SizedBox(
              width: 390,
              height: 296.25,
              child: Assets.images.onb2.image(
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 40),

            /// ================= Bottom Button =================
            CustomButton(
              text: "I’m Ready 💛",
              onTap: () => Get.to(() => const SplashScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
