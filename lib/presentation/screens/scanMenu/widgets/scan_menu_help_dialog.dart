import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors/app_colors.dart';

class ScanMenuHelpDialog extends StatelessWidget {
  const ScanMenuHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity, // overflow এড়াতে
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---- Title ----
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("🌿", style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Tips for a Clear Scan",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🌿", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              /// ---- Subtitle ----
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Your dining sidekick works best when the menu is easy to see. Here's how to glow it up:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF8B7355),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// ---- Tips ----
              _buildTipItem("✨", "Flat & Steady",
                  "Place the menu flat, hold the phone steady.", const Color(0xFFFFCA28)),
              const SizedBox(height: 16),
              _buildTipItem("✨", "Good Lighting",
                  "Natural light is best. Avoid strong reflections.", const Color(0xFFFFCA28)),
              const SizedBox(height: 16),
              _buildTipItem("✨", "No Cropping",
                  "Capture the whole page edge to edge.", const Color(0xFF10B981)),
              const SizedBox(height: 16),
              _buildTipItem("✨", "Sharp & Clear",
                  "Make sure the text is legible for best results.", const Color(0xFFFFCA28)),
              const SizedBox(height: 20),

              /// ---- Special Message ----
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF472B6)),
                ),
                child: Row(
                  children: [
                    const Text("🌸", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF831843),
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(
                              text: "Think of it as taking a photo for friend- ",
                            ),
                            TextSpan(
                              text:
                              "clear, bright, and cozy. The clearer the shot, the better we can guide you!",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🌸", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// ---- Choose How to Scan ----
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Choose How to Scan",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🦋", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// ---- Scan Options ----
              _buildScanOption("📷", "Photo",
                  "Place the menu flat, hold the phone steady."),
              const SizedBox(height: 12),
              _buildScanOption("📄", "PDF",
                  "Natural light is best. Avoid strong reflections."),
              const SizedBox(height: 12),
              _buildScanOption("🔗", "URL",
                  "Capture the whole page edge to edge."),
              const SizedBox(height: 24),

              /// ---- Close Button ----
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Got it!",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---- Helper Widgets ----
  Widget _buildTipItem(String emoji, String title, String desc, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14, color: color, height: 1.4),
              children: [
                TextSpan(text: "$title\n", style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(
                  text: desc,
                  style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanOption(String emoji, String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title – $desc",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
