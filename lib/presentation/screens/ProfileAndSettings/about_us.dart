import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Menu Sidekick was created to help you eat with confidence, clarity, and peace of mind. Dining out can feel overwhelming when you’re balancing dietary needs, allergies, or health goals — so we built this app to make the journey simple and stress-free. With a quick scan, Menu Sidekick highlights meals that fit your lifestyle, suggests easy swaps, and brings you peace of mind across any language so you can focus on enjoying the moment. 🌸✨\n\nStay connected and follow our journey here:",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),

              // 🔗 Instagram Link
              GestureDetector(
                onTap: _launchInstagram,
                child: Text(
                  "📷 Instagram",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
