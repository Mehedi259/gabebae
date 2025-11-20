//lib/presentation/screens/scanMenu/widgets/scan_menu_capture_button.dart
import 'package:flutter/material.dart';

class ScanMenuCaptureButton extends StatelessWidget {
  final String shutterAsset;
  final VoidCallback onCapture;

  const ScanMenuCaptureButton({
    super.key,
    required this.shutterAsset,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCapture,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(shutterAsset),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
