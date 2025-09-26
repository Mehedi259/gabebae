import 'dart:async';
import 'dart:math';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class ProfileSetup6Screen extends StatefulWidget {
  const ProfileSetup6Screen({super.key});

  @override
  State<ProfileSetup6Screen> createState() => _ProfileSetup6ScreenState();
}

class _ProfileSetup6ScreenState extends State<ProfileSetup6Screen> {
  double progress = 0.0;
  final List<bool> _visible = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    // Progress bar animation
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (progress < 1.0) {
        setState(() {
          progress = min(progress + 0.01, 1.0);

          // Update text visibility based on progress
          if (progress >= 0.20) _visible[0] = true;
          if (progress >= 0.40) _visible[1] = true;
          if (progress >= 0.60) _visible[2] = true;
          if (progress >= 0.80) _visible[3] = true;
          if (progress >= 0.95) _visible[4] = true;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 900), () {
          context.go(RoutePath.subscription.addBasePath);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Center(
                child: CircularPercentIndicator(
                  radius: 70,
                  lineWidth: 12,
                  percent: progress,
                  animation: true,
                  animateFromLastPercent: true,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: const Color(0xFFE27B4F),
                  backgroundColor: const Color(0xFFE5E7EB),
                  center: Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _visible[0] ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  "✨ Unlocking your Sidekick’s Superpowers... ✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedOpacity(
                    opacity: _visible[0] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const _FeatureItem(
                      emoji: "🦸‍♀️",
                      text:
                      "Personal Shield → Protects you from foods that don’t fit your diet, allergies, or health 🌿",
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _visible[1] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const _FeatureItem(
                      emoji: "🥦",
                      text:
                      "Ingredient X-Ray Vision → Spots 5,000+ hidden ingredients at a glance",
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _visible[2] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const _FeatureItem(
                      emoji: "📸",
                      text:
                      "Menu Scan Vision → Activating camera, PDF & URL scanning",
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _visible[3] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const _FeatureItem(
                      emoji: "🌎",
                      text:
                      "Global Translator → Reads menus in 20+ languages, no passport required.",
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _visible[4] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const _FeatureItem(
                      emoji: "🤖",
                      text:
                      "AI Wisdom → Powering up tips, swaps & safe suggestions",
                    ),
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

class _FeatureItem extends StatelessWidget {
  final String emoji;
  final String text;
  const _FeatureItem({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
