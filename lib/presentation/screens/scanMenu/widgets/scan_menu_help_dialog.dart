import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/app_colors/app_colors.dart';

class ScanMenuHelpDialog extends StatelessWidget {
  const ScanMenuHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEED8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ---- Tips Section ----
              Text(
                '🌿 ${l10n.tipsForClearScan} 🌿',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF669A59),
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                l10n.tipsForClearScanSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF75360F),
                ),
              ),
              const SizedBox(height: 24),

              /// ---- Tips List ----
              _buildTipItem(
                "✨",
                l10n.tipFlatSteadyTitle,
                l10n.tipFlatSteadyDesc,
                const Color(0xFFE27B4F),
              ),
              const SizedBox(height: 10),

              _buildTipItem(
                "✨",
                l10n.tipGoodLightingTitle,
                l10n.tipGoodLightingDesc,
                const Color(0xFFFFC986),
              ),
              const SizedBox(height: 10),

              _buildTipItem(
                "✨",
                l10n.tipNoCroppingTitle,
                l10n.tipNoCroppingDesc,
                const Color(0xFF669A59),
              ),
              const SizedBox(height: 10),

              _buildTipItem(
                "✨",
                l10n.tipSharpClearTitle,
                l10n.tipSharpClearDesc,
                const Color(0xFF75360F),
              ),
              const SizedBox(height: 24),

              /// ---- Special Message ----
              Text(
                '🌸 ${l10n.tipSpecialMessage} 🌸',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF75360F),
                ),
              ),
              const SizedBox(height: 24),

              /// ---- Choose How to Scan ----
              Text(
                '${l10n.chooseHowToScan} 🦋',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF669A59),
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 24),

              /// ---- Scan Options ----
              _buildScanOption(
                "📷",
                l10n.scanOptionPhoto,
                l10n.scanOptionPhotoDesc,
                const Color(0xFFE27B4F),
              ),
              const SizedBox(height: 10),

              _buildScanOption(
                "📄",
                l10n.scanOptionPDF,
                l10n.scanOptionPDFDesc,
                const Color(0xFFFFC986),
              ),

              const SizedBox(height: 24),

              /// ---- Close Button ----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF669A59),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.gotIt,
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

  Widget _buildTipItem(String emoji, String title, String desc, Color titleColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$emoji ',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE27B4F),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title - ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF75360F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanOption(String emoji, String title, String desc, Color titleColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title – ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF75360F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}