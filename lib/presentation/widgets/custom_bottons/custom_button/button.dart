//lib/presentation/widgets/custom_bottons/custom_button/button.dart
import 'package:flutter/material.dart';

/// =======================================================
/// CustomButton
/// -------------------------------------------------------
/// - Reusable rounded button
/// - Customizable text & action
/// - Consistent shadow, border & color styling
/// =======================================================
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE27B4F), // Primary color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          elevation: 6,
          shadowColor: Colors.black,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "EB Garamond",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
