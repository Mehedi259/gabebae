import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'scan_menu_round_image_button.dart';
import 'scan_menu_capture_button.dart';
import 'scan_menu_mode_button.dart';

class ScanMenuBottomControls extends StatelessWidget {
  final Animation<Offset> slideAnim;
  final Animation<double> pulseAnim;
  final String selectedMode;
  final Function(String) onModeChange;
  final VoidCallback onCapture;
  final VoidCallback onOpenGallery;
  final VoidCallback onToggleFlash;
  final String galleryAsset;
  final String flashAsset;
  final String shutterAsset;

  const ScanMenuBottomControls({
    super.key,
    required this.slideAnim,
    required this.pulseAnim,
    required this.selectedMode,
    required this.onModeChange,
    required this.onCapture,
    required this.onOpenGallery,
    required this.onToggleFlash,
    required this.galleryAsset,
    required this.flashAsset,
    required this.shutterAsset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 96,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: slideAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.positionMenuInFrame,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 16),

              /// ===== PDF & URL Buttons in One Row =====
              Row(
                children: [
                  Expanded(
                    child: ScanMenuModeButton(
                      title: l10n.pdf,
                      isSelected: selectedMode == "PDF",
                      onTap: () => onModeChange("PDF"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ScanMenuModeButton(
                      title: l10n.url,
                      isSelected: selectedMode == "URL",
                      onTap: () => onModeChange("URL"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ===== Bottom Controls =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScanMenuRoundImageButton(
                    asset: galleryAsset,
                    onTap: onOpenGallery,
                  ),
                  ScaleTransition(
                    scale: pulseAnim,
                    child: ScanMenuCaptureButton(
                      shutterAsset: shutterAsset,
                      onCapture: onCapture,
                    ),
                  ),
                  ScanMenuRoundImageButton(
                    asset: flashAsset,
                    onTap: onToggleFlash,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}