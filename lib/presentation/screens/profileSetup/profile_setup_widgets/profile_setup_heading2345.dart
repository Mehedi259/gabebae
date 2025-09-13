import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/custom_assets/assets.gen.dart';
import '../../../../core/routes/route_path.dart';

class ProfileSetupHeading extends StatelessWidget {
  final String stepText;
  final double progress;
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  const ProfileSetupHeading({
    super.key,
    required this.stepText,
    required this.progress,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: Assets.images.backround.image(width: 40, height: 40),
              splashRadius: 24,
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  stepText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: onClose ??
                      () => context.go(RoutePath.home.addBasePath),
              icon: Assets.images.crosswhite.image(width: 40, height: 40),
              splashRadius: 24,
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            valueColor:
            const AlwaysStoppedAnimation<Color>(Color(0xFF669A59)),
            backgroundColor: const Color(0xFFE5E7EB),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
