import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import '../../../core/custom_assets/assets.gen.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

/// =======================================================
/// Enter Email Screen
/// =======================================================
/// - AppBar with Back Button
/// - Title: "Sign In"
/// - Email Input Field with Icon + Placeholder
/// - Continue Button (reusing SignInButton)
/// - Scrollable Layout for smaller devices
/// =======================================================
class EnterEmailScreen extends StatelessWidget {
  const EnterEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(RoutePath.onBoarding2.addBasePath),
          icon: Assets.icons.back.svg(
            width: 24,
            height: 24,
          ),
        ),
      ),

      /// ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            /// ---------------- TITLE ----------------
            const Text(
              "Sign In",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 32),

            /// ---------------- EMAIL INPUT ----------------
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF6B7280), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Assets.icons.mailblack.svg(width: 20, height: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                  text: "Continue",
                  onTap: () => context.go(RoutePath.verifyCode.addBasePath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
