//lib/presentation/screens/authentication/signin.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/sign_in_button.dart';

class SignInPopup extends StatelessWidget {
  const SignInPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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

            /// Sign In Buttons
            SignInButton(
              bgColor: const Color(0xFF154452),
              textColor: Colors.white,
              text: l10n.signInWithApple,
              icon: Assets.icons.apple.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.profileSetup1.addBasePath),
            ),
            const SizedBox(height: 16),
            SignInButton(
              bgColor: Colors.white,
              textColor: const Color(0xFF6B7280),
              text: l10n.signInWithGoogle,
              icon: Assets.icons.google.svg(width: 22, height: 22),
              onTap: () => context.go(RoutePath.profileSetup1.addBasePath),
            ),
            const SizedBox(height: 16),
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
                        ..onTap = () {},
                    ),
                    TextSpan(text: l10n.and),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {},
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