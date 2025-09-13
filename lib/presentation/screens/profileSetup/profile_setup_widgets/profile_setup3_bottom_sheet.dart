import 'package:flutter/material.dart';
import 'package:gabebae/core/custom_assets/assets.gen.dart';

class ProfileSetup3BottomSheet extends StatelessWidget {
  const ProfileSetup3BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== Header =====
            const Text(
              "Health-Driven",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 24),

            /// ===== Scrollable Cards =====
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  _buildHealthCard(
                    title: "Asthma",
                    subtitle: "Chronic lung condition",
                    imagePath: Assets.images.celiacDisease.path,
                  ),
                  _buildHealthCard(
                    title: "Kidney Disease",
                    subtitle: "Renal health support",
                    imagePath: Assets.images.celiacDisease.path,
                  ),
                  _buildHealthCard(
                    title: "Thyroid Issues",
                    subtitle: "Hyper / Hypo thyroidism",
                    imagePath: Assets.images.celiacDisease.path,
                  ),
                  _buildHealthCard(
                    title: "Heart Disease",
                    subtitle: "Cardiac health",
                    imagePath: Assets.images.celiacDisease.path,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// Reusable Card (No Switch Here)
  /// ===============================
  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F5),
              border: Border.all(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
