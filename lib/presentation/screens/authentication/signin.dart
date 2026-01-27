import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/sign_in_button.dart';
import '../../../core/controllers/sign_in_controller.dart';

class SignInPopup extends StatelessWidget {
  const SignInPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final SignInController controller = Get.put(SignInController());

    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    l10n.signIn,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF154452),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.icons.cross.svg(width: 35, height: 35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Sign In with Apple Button
            Obx(() => SignInButton(
              bgColor: const Color(0xFF154452),
              textColor: Colors.white,
              text: l10n.signInWithApple,
              icon: Assets.icons.apple.svg(width: 22, height: 22),
              isLoading: controller.isAppleLoading.value,
              onTap: () async {
                final result = await controller.signInWithApple(context);
                if (result['success']) {
                  // Navigate to profile setup or home based on 'created' flag
                  if (result['data']?['created'] == true) {
                    // New user - go to profile setup
                    context.go(RoutePath.profileSetup1.addBasePath);
                  } else {
                    // Existing user - go to home or appropriate screen
                    // You can check if profile is complete here
                    context.go(RoutePath.profileSetup1.addBasePath);
                  }
                }
              },
            )),
            const SizedBox(height: 16),

            /// Sign In with Google Button
            Obx(() => SignInButton(
              bgColor: Colors.white,
              textColor: const Color(0xFF6B7280),
              text: l10n.signInWithGoogle,
              icon: Assets.icons.google.svg(width: 22, height: 22),
              isLoading: controller.isGoogleLoading.value,
              onTap: () async {
                final result = await controller.signInWithGoogle(context);
                if (result['success']) {
                  // Navigate to profile setup or home based on 'created' flag
                  if (result['data']?['created'] == true) {
                    // New user - go to profile setup
                    context.go(RoutePath.profileSetup1.addBasePath);
                  } else {
                    // Existing user - go to home or appropriate screen
                    context.go(RoutePath.profileSetup1.addBasePath);
                  }
                }
              },
            )),
            const SizedBox(height: 16),

            /// Sign In with Email Button
            SignInButton(
              bgColor: Colors.white,
              textColor: const Color(0xFF6B7280),
              text: l10n.signInWithEmail,
              icon: Assets.icons.mail.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.enterEmail.addBasePath),
            ),
            const SizedBox(height: 24),

            /// Terms & Conditions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text.rich(
                TextSpan(
                  text: l10n.byContinuing,
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 12,
                    color: Color(0xFF154452),
                  ),
                  children: [
                    TextSpan(
                      text: l10n.termsAndConditions,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle terms tap
                        },
                    ),
                    TextSpan(text: l10n.and),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle privacy policy tap
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}