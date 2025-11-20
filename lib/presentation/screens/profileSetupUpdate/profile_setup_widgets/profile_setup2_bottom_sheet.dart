// lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup2_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/profile_setup_controller.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup2BottomSheet extends StatelessWidget {
  const ProfileSetup2BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ProfileSetupController controller = Get.find<ProfileSetupController>();

    return Container(
      height: 680,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ====== Heading ======
          Container(
            width: 342,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              l10n.healthDriven,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF669A59),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          /// ====== Scrollable Body ======
          Expanded(
            child: Obx(() {
              // Get remaining allergies (skip first 5 shown on main screen)
              final remainingAllergies = controller.allergies.length > 5
                  ? controller.allergies.sublist(5)
                  : <dynamic>[];

              if (remainingAllergies.isEmpty) {
                return const Center(
                  child: Text('No additional allergies available'),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: remainingAllergies.map((allergy) {
                    return Obx(() {
                      final bool isSelected = controller.selectedAllergies.contains(allergy.allergyName);

                      return GestureDetector(
                        onTap: () {
                          controller.toggleAllergy(allergy.allergyName);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE27B4F)
                                  : const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              /// Icon/Image
                              Image.network(
                                allergy.allergyIcon,
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.no_food, size: 30);
                                },
                              ),
                              const SizedBox(width: 16),

                              /// Title
                              Expanded(
                                child: Text(
                                  allergy.allergyName,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          /// ====== Custom Button ======
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: l10n.looksGood,
              onTap: () => context.go(RoutePath.profileSetup3.addBasePath),
            ),
          ),
        ],
      ),
    );
  }
}