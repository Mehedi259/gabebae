import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/custom_assets/assets.gen.dart';


class ScanMenuModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ScanMenuModeButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Choose the correct icon based on title
    Widget icon;
    switch (title) {
      case "PDF":
        icon = Image.asset(
          Assets.images.campdf.path,
          width: 14,
          height: 14,
          fit: BoxFit.cover,
        );
        break;
      case "URL":
        icon = Image.asset(
          Assets.images.camurl.path,
          width: 14,
          height: 14,
          fit: BoxFit.cover,
        );
        break;
      default:
        icon = const SizedBox();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFFFF) : const Color(0x33FFFFFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF374151) : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
