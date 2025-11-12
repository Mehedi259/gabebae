//lib/presentation/screens/authentication/forget_password.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import '../../../core/controllers/sign_in_controller.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

/// =======================================================
/// Enter Email Screen
/// =======================================================
/// - AppBar with Back Button
/// - Title: "Sign In"
/// - Email Input Field with Icon + Placeholder
/// - Continue Button with API Integration
/// - Loading state management
/// - Scrollable Layout for smaller devices
/// =======================================================
class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Obx(() => controller.isLoading.value
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        )
            : CustomButton(
          text: "Continue",
          onTap: () async {
            final success = await controller.requestOtp(context);
            if (success) {
              // Navigate to OTP screen with email
              context.go(
                RoutePath.verifyCode.addBasePath,
                extra: controller.emailController.text.trim(),
              );
            }
          },
        )),
      ),

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
                  Expanded(
                    child: TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
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
                      enabled: !controller.isLoading.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Controller will be disposed by GetX
    super.dispose();
  }
}