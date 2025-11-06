//lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup2_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/custom_bottons/custom_button/button.dart';
/// ===============================================
/// Profile Setup - Step 2
/// Bottom Sheet : Additional Food Allergens Selection
/// ===============================================
class ProfileSetup2BottomSheet extends StatefulWidget {
  const ProfileSetup2BottomSheet({super.key});

  @override
  State<ProfileSetup2BottomSheet> createState() =>
      _ProfileSetup2BottomSheetState();
}

class _ProfileSetup2BottomSheetState extends State<ProfileSetup2BottomSheet> {
  /// Multiple selection support
  final List<String> selectedOptions = [];

  List<Map<String, String>> _getLocalizedOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      {"title": l10n.salad, "image": Assets.images.vegan.path},
      {"title": l10n.onion, "image": Assets.images.whole30.path},
      {"title": l10n.banana, "image": Assets.images.dash.path},
      {"title": l10n.pineapple, "image": Assets.images.mediterranean.path},
      {"title": l10n.mrBanana, "image": Assets.images.dash.path},
      {"title": l10n.rawFood, "image": Assets.images.whole30.path},
      {"title": l10n.paleo, "image": Assets.images.paleo.path},
      {"title": l10n.keto, "image": Assets.images.keto.path},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = _getLocalizedOptions(context);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                children: options.map((item) {
                  final bool isSelected =
                  selectedOptions.contains(item["title"]);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedOptions.remove(item["title"]);
                        } else {
                          selectedOptions.add(item["title"]!);
                        }
                      });
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
                              ? const Color(0xFFE27B4F) // Primary Color
                              : const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          /// Icon/Image
                          Image.asset(
                            item["image"]!,
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 16),

                          /// Title only (subtitle removed)
                          Expanded(
                            child: Text(
                              item["title"]!,
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
                }).toList(),
              ),
            ),
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