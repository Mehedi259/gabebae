// lib/presentation/screens/ProfileAndSettings/privacy_policy.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
    final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
        title: Text(
          "Privacy Policy",
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
          final privacyContent = controller.privacyPolicyData.value?.content ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Display API Content or Fallback
                if (privacyContent.isNotEmpty)
                  _buildParagraph(privacyContent)
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
          "Menu Sidekick helps you make more informed food choices by scanning menus, highlighting ingredients, and offering personalized suggestions. This Privacy Policy explains how we collect, use, and share information when you use our mobile application, related websites, and services (collectively, the Service).\n\nBy using the Service, you agree to this Privacy Policy.",
        ),

        _buildSectionTitle("1. Information"),
        _buildParagraph(
          "We may collect the following categories of information:\n\n• Account Information: If you create an account, we may collect your name, email, password, and profile settings.\n• Profile & Preferences: Diets, allergies, restrictions, and goals you provide to personalize your experience.\n• Usage Information: Details about how you interact with the Service, such as menu scans, selections, and app features you use.\n• Device & Technical Data: Device type, operating system, IP address, app version, language, time zone, and crash or performance reports.\n• Payment & Subscription Info: If you purchase a subscription, Apple App Store or Google Play processes payments; we may receive confirmation of purchase.\n• Communications: Information you provide when contacting support, participating in app feedback, or opening our emails. We may track engagement (e.g., whether you opened an email) to improve communications.\n• Location (Optional): If enabled, approximate location may be used for regional menu support or localization.",
        ),

        _buildSectionTitle("2. How We Use Information"),
        _buildParagraph(
          "We use information to:\n\n• Provide and personalize the Service (e.g., apply your filters and show safe/unsafe flags).\n• Improve app performance, accuracy, and user experience.\n• Respond to questions and provide customer support.\n• Send updates, offers, and communications (you may opt out anytime).\n• Monitor safety, detect misuse, and protect against fraud or abuse.\n• Comply with legal and regulatory obligations.",
        ),
      ],
    );
  }

  // Helper method to format date
}