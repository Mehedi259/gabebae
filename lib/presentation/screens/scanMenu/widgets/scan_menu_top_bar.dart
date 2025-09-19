import 'package:flutter/material.dart';
import 'scan_menu_round_icon_button.dart';

class ScanMenuTopBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onHelp;

  const ScanMenuTopBar({
    super.key,
    required this.onClose,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScanMenuRoundIconButton(icon: Icons.close, onTap: onClose),
          ScanMenuRoundIconButton(icon: Icons.help_outline, onTap: onHelp),
        ],
      ),
    );
  }
}
