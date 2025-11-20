// lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup4_bottom_sheet.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/profile_setup_controller.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileSetup4BottomSheet extends StatelessWidget {
  const ProfileSetup4BottomSheet({super.key});

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
                  Text(
                    l10n.healthDriven,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF669A59),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Obx(() {
                    // Get remaining items (skip first 4)
                    final remainingItems = controller.magicList.length > 4
                        ? controller.magicList.sublist(4)
                        : <String>[];

                    if (remainingItems.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No additional items'),
                        ),
                      );
                    }

                    return Column(
                      children: remainingItems.map((item) {
                        return Obx(() {
                          final bool isActive = controller.selectedMagicListItems.contains(item);

                          return _buildMagicListCard(
                            controller: controller,
                            item: item,
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
                text: l10n.readyToGlow,
                onTap: () => context.go(RoutePath.profileSetup5.addBasePath),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMagicListCard({
    required ProfileSetupController controller,
    required String item,
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
            child: const Center(
              child: Icon(
                Icons.no_food,
                size: 24,
                color: Color(0xFF669A59),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              controller.toggleMagicListItem(item);
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