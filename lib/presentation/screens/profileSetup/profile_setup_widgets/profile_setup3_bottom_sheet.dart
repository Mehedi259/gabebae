// lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup3_bottom_sheet.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/profile_setup_controller.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileSetup3BottomSheet extends StatelessWidget {
  const ProfileSetup3BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ProfileSetupController controller = Get.find<ProfileSetupController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
              child: ListView(
                controller: scrollController,
                children: [
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
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Obx(() {
                    // Get remaining conditions (skip first 4)
                    final remainingConditions = controller.medicalConditions.length > 4
                        ? controller.medicalConditions.sublist(4)
                        : <dynamic>[];

                    if (remainingConditions.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No additional medical conditions'),
                        ),
                      );
                    }

                    return Column(
                      children: remainingConditions.map((condition) {
                        return Obx(() {
                          final bool isActive = controller.selectedMedicalConditions
                              .contains(condition.medicalConditionName);

                          return _buildHealthCard(
                            controller: controller,
                            conditionName: condition.medicalConditionName,
                            title: condition.medicalConditionName,
                            subtitle: condition.medicalDescription,
                            imagePath: condition.medicalConditionIcon,
                            isActive: isActive,
                          );
                        });
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),

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

  Widget _buildHealthCard({
    required ProfileSetupController controller,
    required String conditionName,
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isActive,
  }) {
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F5),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Center(
              child: Image.network(
                imagePath,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.health_and_safety, size: 24);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

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

          GestureDetector(
            onTap: () {
              controller.toggleMedicalCondition(conditionName);
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