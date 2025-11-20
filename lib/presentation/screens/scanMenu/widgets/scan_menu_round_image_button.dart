//lib/presentation/screens/scanMenu/widgets/scan_menu_round_image_button.dart
import 'package:flutter/material.dart';

class ScanMenuRoundImageButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const ScanMenuRoundImageButton({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
        child: Image.asset(asset, width: 56, height: 56),
    );
  }
}
