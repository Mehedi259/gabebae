import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import '../authentication/signin.dart';

class OnBoarding2Screen extends StatelessWidget {
  const OnBoarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.imReady,
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
        child: Column(
          children: [
            /// Progress Indicator
            const SizedBox(height: 16),
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

            /// Title Text
            Text(
              l10n.howItWorks,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 32 / 24,
                color: Color(0xFF0F5132),
              ),
            ),

            const SizedBox(height: 40),

            /// Body (Scrollable)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Illustration Image
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

                      /// Middle Container (Subtitle + Description)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.scanMenuMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "EB Garamond",
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              height: 1.25,
                              color: Color(0xFFE27B4F),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.personalizedMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}