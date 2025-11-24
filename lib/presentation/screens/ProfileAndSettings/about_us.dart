// lib/presentation/screens/ProfileAndSettings/about_us.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/about_us_controller.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // 🔗 Instagram link launcher
  Future<void> _launchInstagram() async {
    final Uri url = Uri.parse("https://instagram.com/menusidekick");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AboutUsController controller = Get.put(AboutUsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
        title: const Text(
          "About us",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            );
          }

          // Success State - Display Content
          final aboutUsContent = controller.aboutUsData.value?.content ?? '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display API Content
                if (aboutUsContent.isNotEmpty)
                  Text(
                    aboutUsContent,
                    style: GoogleFonts.poppins(fontSize: 14),
                  )
                else
                // Fallback text if API returns empty content
                  Text(
                    "Menu Sidekick was created to help you eat with confidence, clarity, and peace of mind. Dining out can feel overwhelming when you're balancing dietary needs, allergies, or health goals — so we built this app to make the journey simple and stress-free. With a quick scan, Menu Sidekick highlights meals that fit your lifestyle, suggests easy swaps, and brings you peace of mind across any language so you can focus on enjoying the moment. 🌸✨\n\nStay connected and follow our journey here:",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),

                const SizedBox(height: 16),

                // 🔗 Instagram Link
                GestureDetector(
                  onTap: _launchInstagram,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Instagram",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper method to format date
}