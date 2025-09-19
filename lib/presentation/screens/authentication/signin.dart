import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/sign_in_button.dart'; // ✅ import

/// =======================================================
/// SignIn Popup (Bottom Sheet) with Scroll
/// =======================================================
class SignInPopup extends StatelessWidget {
  const SignInPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// ---------------- HEADER ----------------
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
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF154452),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.icons.cross.svg(
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ---------------- SIGN IN BUTTONS ----------------
            SignInButton(
              bgColor: const Color(0xFF154452),
              textColor: Colors.white,
              text: "Sign In with Apple",
              icon: Assets.icons.apple.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.profileSetup1.addBasePath),
            ),
            const SizedBox(height: 16),
            SignInButton(
              bgColor: Colors.white,
              textColor: const Color(0xFF6B7280),
              text: "Sign In with Google",
              icon: Assets.icons.google.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.profileSetup1.addBasePath),
            ),
            const SizedBox(height: 16),
            SignInButton(
              bgColor: Colors.white,
              textColor: const Color(0xFF6B7280),
              text: "Sign In with Email",
              icon: Assets.icons.mail.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.enterEmail.addBasePath),
            ),

            const SizedBox(height: 24),

            /// ---------------- TERMS & CONDITIONS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text.rich(
                TextSpan(
                  text: "By continuing, you agree to Cal Al's ",
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 12,
                    color: Color(0xFF154452),
                  ),
                  children: [
                    TextSpan(
                      text: "Terms and Conditions",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go(RoutePath.termsAndCondition.addBasePath),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go(RoutePath.privacyPolicy.addBasePath),
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
