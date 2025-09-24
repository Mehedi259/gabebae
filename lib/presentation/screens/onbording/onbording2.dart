import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import '../authentication/signin.dart';

/// =======================================================
/// OnBoarding2Screen (with scrollable content)
/// =======================================================
class OnBoarding2Screen extends StatelessWidget {
  const OnBoarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Assets.images.onb2.image(
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ============= Middle Container (Subtitle + Description) =============
                const SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Simply scan any menu and see\n"
                                "what’s right for you",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "EB Garamond",
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              height: 1.25,
                              color: Color(0xFFE27B4F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Personalized for your diet, allergies, and\n"
                            "health 🌿 — even across languages 🌎",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
