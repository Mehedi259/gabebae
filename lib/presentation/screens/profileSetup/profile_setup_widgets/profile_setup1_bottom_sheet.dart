// lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup1_bottom_sheet.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/profile_setup_controller.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/custom_bottons/custom_button/button.dart';
import 'profile_setup1_balance_controller_popup.dart';

class ProfileSetup1BottomSheet extends StatefulWidget {
  const ProfileSetup1BottomSheet({super.key});

  @override
  State<ProfileSetup1BottomSheet> createState() =>
      _ProfileSetup1BottomSheetState();
}

class _ProfileSetup1BottomSheetState extends State<ProfileSetup1BottomSheet> {
  final ProfileSetupController profileController = Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            padding: const EdgeInsets.symmetric(horizontal: 15),
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

          /// ====== Scrollable Options (6th item থেকে শুরু) ======
          Expanded(
            child: Obx(() {
              final remainingItems = profileController.eatingStyles.length > 5
                  ? profileController.eatingStyles.sublist(5)
                  : <dynamic>[];

              if (remainingItems.isEmpty) {
                return const Center(
                  child: Text(
                    'No more items',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      decoration: TextDecoration.none,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: remainingItems.map((eatingStyle) {
                    final title = eatingStyle.eatingStyleName;
                    final subtitle = eatingStyle.details ?? '';
                    final image = eatingStyle.eatingStyleIcon;
                    final bool isSelected = profileController.selectedEatingStyles.containsKey(title);

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          profileController.selectedEatingStyles.remove(title);
                        } else {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: '',
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, anim1, anim2) {
                              return const SizedBox.shrink();
                            },
                            transitionBuilder: (context, anim1, anim2, child) {
                              return Transform.scale(
                                scale: Curves.easeOutBack.transform(anim1.value),
                                child: Opacity(
                                  opacity: anim1.value,
                                  child: Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: const EdgeInsets.all(24),
                                    child: ProfileSetup1BalanceControllerPopup(
                                      eatingStyleName: title,
                                      onLevelSelected: (level) {
                                        profileController.toggleEatingStyle(title, level);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
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
                            Image.network(
                              image,
                              width: 30,
                              height: 30,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.restaurant, size: 30);
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                      decoration: TextDecoration.none,
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
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          /// ====== Bottom Next Button ======
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: l10n.nextUp,
              onTap: () => context.go(RoutePath.profileSetup2.addBasePath),
            ),
          ),
        ],
      ),
    );
  }
}