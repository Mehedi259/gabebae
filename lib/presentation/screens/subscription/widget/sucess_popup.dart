import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/custom_assets/assets.gen.dart';
import '../../../../core/routes/route_path.dart';

class SuccessPopup extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessPopup({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B5FBF),
              Color(0xFF6B46C1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: SingleChildScrollView( // ✅ scrollable করে দিলাম
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Celebration Icon
                  Container(
                    child: Assets.images.congrats.image(width: 100, height: 100),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    "Congrats,\nBeautiful Soul!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.4,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subtitle
                  Text(
                    "Welcome to the Menu Sidekick family—\nyour dining glow-up starts now! ✨",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.5,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Share Button
                  GestureDetector(
                    onTap: () async {
                      await Share.share(
                        '🎉 I just joined Menu Sidekick! 🚀\n'
                            'Your dining glow-up starts here – check it out now:\n'
                            'https://menusidekick.app',
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "Share Menu Sidekick with\nFamily and Friends!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6A3EA1),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Continue Button
                  GestureDetector(
                    onTap: () => context.go(RoutePath.privacyPolicyPs.addBasePath),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B35),
                            Color(0xFFE85A2B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
