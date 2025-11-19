//lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup1_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_setup1_balance_controller_popup.dart';
import '../../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup1BottomSheet extends StatefulWidget {
  const ProfileSetup1BottomSheet({super.key});

  @override
  State<ProfileSetup1BottomSheet> createState() =>
      _ProfileSetup1BottomSheetState();
}

class _ProfileSetup1BottomSheetState extends State<ProfileSetup1BottomSheet> {
  String? selectedOption;

  List<Map<String, String>> _getLocalizedOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      {
        "title": "Flexitarian",
        "subtitle": l10n.varietyHealthy,
        "image": Assets.images.vegan.path,
      },
      {
        "title": "Whole30",
        "subtitle": "30-day clean eating",
        "image": Assets.images.whole30.path,
      },
      {
        "title": "DASH",
        "subtitle": "Low salt, heart-friendly",
        "image": Assets.images.dash.path,
      },
      {
        "title": "Mediterranean",
        "subtitle": "Olive oil, fish, grains",
        "image": Assets.images.mediterranean.path,
      },
      {
        "title": "Low-FODMAP",
        "subtitle": "Gut-friendly carb limits",
        "image": Assets.images.dash.path,
      },
      {
        "title": "Raw Food",
        "subtitle": "Uncooked plant-based meals",
        "image": Assets.images.whole30.path,
      },
      {
        "title": l10n.paleo,
        "subtitle": l10n.wholeFoodsOnly,
        "image": Assets.images.paleo.path,
      },
      {
        "title": l10n.keto,
        "subtitle": l10n.lowCarbHighFat,
        "image": Assets.images.keto.path,
      },
    ];
  }

  void _openBalanceControllerPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: ProfileSetup1BalanceControllerPopup(eatingStyleName: '',onLevelSelected: (String level) {  },),
            ),
          ),
        );
      },
    );
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

          /// ====== Scrollable Options ======
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                children: options.map((item) {
                  final bool isSelected = selectedOption == item["title"];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = item["title"];
                      });
                      _openBalanceControllerPopup();
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
                          Image.asset(
                            item["image"]!,
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item["title"]!,
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
                                  item["subtitle"]!,
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
            ),
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