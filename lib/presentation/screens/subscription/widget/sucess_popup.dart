import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class SuccessPopup extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessPopup({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF4B2EFF), // Deep Purple Background
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🎉 Confetti Icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE4C4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.celebration,
                  color: Colors.orange.shade600,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🎊 Title
            Text(
              "Congrats,\nBeautiful Soul!",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              "Welcome to the Menu Sidekick family—\n"
                  "your dining glow-up starts now! ✨",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E6),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "Share Menu Sidekick with\nFamily and Friends!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4B2EFF),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Continue Button
            GestureDetector(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE27B4F),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
