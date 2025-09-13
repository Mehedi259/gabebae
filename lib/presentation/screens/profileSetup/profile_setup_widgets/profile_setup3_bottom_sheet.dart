import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup3BottomSheet extends StatefulWidget {
  const ProfileSetup3BottomSheet({super.key});

  @override
  State<ProfileSetup3BottomSheet> createState() =>
      _ProfileSetup3BottomSheetState();
}

class _ProfileSetup3BottomSheetState extends State<ProfileSetup3BottomSheet> {
  /// Track switch states
  final Map<String, bool> _switchStates = {
    "Asthma": false,
    "Kidney Disease": false,
    "Thyroid Issues": false,
    "Heart Disease": false,
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            /// ===== Scrollable Content =====
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
              child: ListView(
                controller: controller,
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

                  /// ===== Cards =====
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

            /// ===== Fixed Bottom Button =====
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                text: "All set here 💛",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// Reusable Card With Custom Switch
  /// ===============================
  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    final bool isActive = _switchStates[title] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
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
              border: Border.all(color: const Color(0xFFE5E7EB)),
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
          Expanded(
            child: Column(
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
          ),

          /// Custom Switch
          GestureDetector(
            onTap: () {
              setState(() {
                _switchStates[title] = !isActive;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 44,
              height: 24,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFD1D5DB),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                alignment:
                isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
