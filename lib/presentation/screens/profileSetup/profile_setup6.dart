import 'dart:async';
import 'dart:math';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:go_router/go_router.dart';

class ProfileSetup6Screen extends StatefulWidget {
  const ProfileSetup6Screen({super.key});

  @override
  State<ProfileSetup6Screen> createState() => _ProfileSetup6ScreenState();
}

class _ProfileSetup6ScreenState extends State<ProfileSetup6Screen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (progress < 1.0) {
        setState(() {
          progress = min(progress + 0.02, 1.0);
        });
      } else {
        timer.cancel();

        Future.delayed(const Duration(milliseconds: 900), () {
          context.go(RoutePath.home.addBasePath);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8),
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
              const Text(
                "✨ Unlocking your Sidekick’s Superpowers... ✨",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 24),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeatureItem(
                    emoji: "🙅‍♀️",
                    text:
                    "Personal Shield → Protects you from foods that don’t fit your diet, allergies, or health 🌿",
                  ),
                  _FeatureItem(
                    emoji: "🥦",
                    text:
                    "Ingredient X-Ray Vision → Spots 5,000+ hidden ingredients at a glance",
                  ),
                  _FeatureItem(
                    emoji: "📷",
                    text:
                    "Menu Scan Vision → Activating camera, PDF & URL scanning",
                  ),
                  _FeatureItem(
                    emoji: "🌍",
                    text:
                    "Global Translator → Reads menus in 20+ languages, no passport required.",
                  ),
                  _FeatureItem(
                    emoji: "🤖",
                    text:
                    "AI Wisdom → Powering up tips, swaps & safe suggestions",
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
