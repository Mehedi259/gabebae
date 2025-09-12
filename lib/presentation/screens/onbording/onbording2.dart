import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import '../authentication/signin.dart';

/// =======================================================
/// OnBoarding2Screen
/// -------------------------------------------------------
/// - Responsive (double.infinity for width)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Dot 1 (Inactive)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF6B35),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                ),
              ],
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
              width: double.infinity,
              height: 296,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Assets.images.onb2.image(
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ================= Bottom Button =================
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: "I’m Ready 💛",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                      builder: (_) => const SignInPopup(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
