//lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup3_bottom_sheet.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileSetup3BottomSheet extends StatefulWidget {
  const ProfileSetup3BottomSheet({super.key});

  @override
  State<ProfileSetup3BottomSheet> createState() =>
      _ProfileSetup3BottomSheetState();
}

class _ProfileSetup3BottomSheetState extends State<ProfileSetup3BottomSheet> {
  /// Track switch states for health conditions - using language-independent keys
  final Map<String, bool> _switchStates = {
    "asthma": false,
    "kidneyDisease": false,
    "thyroidIssues": false,
    "heartDisease": false,
  };

  List<Map<String, dynamic>> _getLocalizedHealthConditions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      {
        "key": "asthma",
        "title": l10n.asthma,
        "subtitle": l10n.chronicLungCondition,
        "image": Assets.images.celiacDisease.path,
      },
      {
        "key": "kidneyDisease",
        "title": l10n.kidneyDisease,
        "subtitle": l10n.renalHealthSupport,
        "image": Assets.images.hypertension.path,
      },
      {
        "key": "thyroidIssues",
        "title": l10n.thyroidIssues,
        "subtitle": l10n.hyperHypoThyroidism,
        "image": Assets.images.highCholesterol.path,
      },
      {
        "key": "heartDisease",
        "title": l10n.heartDisease,
        "subtitle": l10n.cardiacHealth,
        "image": Assets.images.diabetes.path,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final healthConditions = _getLocalizedHealthConditions(context);

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
                  /// ===== Updated Health-Driven Header =====
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        l10n.healthDriven,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF669A59),
                          height: 1.6, // line-height: 32px (18 * 1.6 ≈ 32)
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ===== Cards =====
                  ...healthConditions.map((condition) {
                    return _buildHealthCard(
                      conditionKey: condition["key"] as String,
                      title: condition["title"] as String,
                      subtitle: condition["subtitle"] as String,
                      imagePath: condition["image"] as String,
                    );
                  }).toList(),
                ],
              ),
            ),

            /// ===== Fixed Bottom Button =====
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                text: l10n.allSetHere,
                onTap: () => context.go(RoutePath.profileSetup4.addBasePath),
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
    required String conditionKey,
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    final bool isActive = _switchStates[conditionKey] ?? false;

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

          /// Title & Subtitle
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
                _switchStates[conditionKey] = !isActive;
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