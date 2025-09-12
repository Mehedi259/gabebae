import 'package:flutter/material.dart';

/// =======================================================
/// Reusable Sign In Button
/// =======================================================
class SignInButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const SignInButton({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ দুই পাশে 20px margin
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: bgColor == Colors.white ? 1 : 0,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
