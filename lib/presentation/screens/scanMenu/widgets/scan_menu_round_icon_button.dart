import 'package:flutter/material.dart';

class ScanMenuRoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ScanMenuRoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white24,
        radius: 20,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
