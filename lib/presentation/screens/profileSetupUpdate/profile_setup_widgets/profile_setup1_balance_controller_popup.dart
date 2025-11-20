// lib/presentation/screens/profileSetup/profile_setup_widgets/profile_setup1_balance_controller_popup.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/custom_assets/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileSetup1BalanceControllerPopup extends StatefulWidget {
  final String eatingStyleName;
  final Function(String level) onLevelSelected;

  const ProfileSetup1BalanceControllerPopup({
    super.key,
    required this.eatingStyleName,
    required this.onLevelSelected,
  });

  @override
  State<ProfileSetup1BalanceControllerPopup> createState() =>
      _ProfileSetup1BalanceControllerPopupState();
}

class _ProfileSetup1BalanceControllerPopupState
    extends State<ProfileSetup1BalanceControllerPopup> {
  double dragValue = 0.5;

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      if (dragValue < 0.25) {
        dragValue = 0.0;
      } else if (dragValue < 0.75) {
        dragValue = 0.5;
      } else {
        dragValue = 1.0;
      }
    });
  }

  int get selectedIndex {
    if (dragValue == 0.0) return 0;
    if (dragValue == 1.0) return 2;
    return 1;
  }

  String get selectedLevel {
    if (selectedIndex == 0) return 'flexible';
    if (selectedIndex == 2) return 'strict';
    return 'balanced';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final dietOptions = [
      {"title": l10n.flexible, "image": Assets.images.flexible.path, "level": "flexible"},
      {"title": l10n.balanced, "image": Assets.images.balanced.path, "level": "balanced"},
      {"title": l10n.strict, "image": Assets.images.strict.path, "level": "strict"},
    ];

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                widget.eatingStyleName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),

              // Level options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dietOptions.length, (index) {
                  final option = dietOptions[index];
                  return Column(
                    children: [
                      Image.asset(option["image"]!, width: 32, height: 32),
                      const SizedBox(height: 8),
                      Text(
                        option["title"]!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Slider
              SizedBox(
                width: double.infinity,
                height: 48,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth - 48;
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999.r),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFEF3C7),
                                Color(0xFFD1FAE5),
                                Color(0xFF6CA865),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: dragValue * maxWidth,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                dragValue += details.delta.dx / maxWidth;
                                dragValue = dragValue.clamp(0.0, 1.0);
                              });
                            },
                            onHorizontalDragEnd: _onDragEnd,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF6CA865),
                                  width: 4,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x19000000),
                                    blurRadius: 15,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  dietOptions[selectedIndex]["image"]!,
                                  width: 20,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Selected level display
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x336CA865),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      dietOptions[selectedIndex]["title"]!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6CA865),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.varietyHealthy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),

              // Confirm button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onLevelSelected(selectedLevel);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA865),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                     'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}