// lib/presentation/screens/ProfileAndSettings/terms_and_condition.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/terms_condition_controller.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black87,
        height: 1.6,
      ),
    );
  }

  Widget _buildRich(String bold, String normal) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
        children: [
          TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: normal),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TermsConditionController controller = Get.put(TermsConditionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
        title: Text(
          "Terms of Service",
          style: GoogleFonts.poppins(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          // Loading State
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error State
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.retry(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success State - Display Content
          final termsContent = controller.termsConditionData.value?.content ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Display API Content or Fallback
                if (termsContent.isNotEmpty)
                  _buildParagraph(termsContent)
                else
                  _buildFallbackContent(),

                const SizedBox(height: 80),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Fallback content (your existing hardcoded content)
  Widget _buildFallbackContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRich("Effective Date: ", "September 22, 2025"),
        _buildRich("Entity: ", "Menu Sidekick, LLC (Menu Sidekick, we, us, or our)"),
        _buildRich("Contact: ", "MenuSidekick@gmail.com"),
        _buildRich("Website: ", "MenuSidekick.app"),
        const SizedBox(height: 12),

        _buildParagraph(
          "These Terms of Service (Terms) form a legally binding agreement between you and Menu Sidekick regarding your use of our mobile application, related websites, and services (collectively, the Service).\n\nBy clicking I Accept or by downloading, installing, accessing, or using the Service, you agree to these Terms and our Privacy Policy. If you do not agree, you may not use the Service.",
        ),

        _buildRich(
          "Important Disclaimer: ",
          "Menu Sidekick is designed to help you make more informed food choices by scanning menus, highlighting ingredients, and offering suggestions. It does not provide medical advice. Always confirm with restaurant staff and consult a qualified professional for health-related concerns.",
        ),

        _buildSectionTitle("1. Service Overview"),
        _buildParagraph(
          "Menu Sidekick helps users:\n• Scan menus via camera, upload, or text input.\n• Apply filters for diets, allergies, and preferences.\n• View ingredient tags, safety flags, and suggested modifications.\n• Share dining preferences with restaurants via QR codes.\n• Receive tips, substitutions, and information through Menu Sidekick AI.\n\nThe Service is provided for informational and wellness purposes only.",
        ),

        _buildSectionTitle("2. Eligibility"),
        _buildParagraph(
          "• You must be at least 18 years old to use the Service.\n• By using the Service, you confirm that:\n(a) you are 18 or older;\n(b) you have not been suspended or removed from the Service;\n(c) your use complies with all applicable laws.",
        ),

        _buildSectionTitle("3. Accounts"),
        _buildParagraph(
          "• You may need an account to use certain features. Provide accurate information and keep it updated.\n• You are responsible for safeguarding your login.",
        ),
        _buildRich("Contact: ", "MenuSidekick@gmail.com if you suspect unauthorized use."),
      ],
    );
  }

  // Helper method to format date
}