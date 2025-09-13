import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/custom_assets/assets.gen.dart';

/// =============================================================
/// Profile Setup 1 - Diet Balance Controller Popup (Smooth Drag)
/// =============================================================
class ProfileSetup1BalanceControllerPopup extends StatefulWidget {
  const ProfileSetup1BalanceControllerPopup({super.key});

  @override
  State<ProfileSetup1BalanceControllerPopup> createState() =>
      _ProfileSetup1BalanceControllerPopupState();
}

class _ProfileSetup1BalanceControllerPopupState
    extends State<ProfileSetup1BalanceControllerPopup> {
  /// Current drag position (0.0 = Flexible, 0.5 = Balanced, 1.0 = Strict)
  double dragValue = 0.5;

  /// Options (title + image)
  final List<Map<String, String>> dietOptions = [
    {"title": "Flexible", "image": Assets.images.flexible.path},
    {"title": "Balanced", "image": Assets.images.balanced.path},
    {"title": "Strict", "image": Assets.images.strict.path},
  ];

  /// Snap to nearest option after drag release
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: double.infinity,
          height: 300,
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
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ================== Top Options ==================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dietOptions.length, (index) {
                  final option = dietOptions[index];
                  return Column(
                    children: [
                      Image.asset(
                        option["image"]!,
                        width: 32,
                        height: 32,
                      ),
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

              /// ================== Gradient Bar + Movable Controller ==================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth - 48;

                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        /// Gradient bar
                        Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999.r),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFEF3C7),
                                Color(0xFFD1FAE5),
                                Color(0xFF6CA865),
                              ],
                            ),
                          ),
                        ),

                        /// Dragable controller
                        Positioned(
                          left: dragValue * maxWidth,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                dragValue +=
                                    details.delta.dx / maxWidth;
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
                                  BoxShadow(
                                    color: Color(0x19000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
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

              /// ================== Button + Description ==================
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
                  const Text(
                    "You enjoy variety while maintaining healthy choices",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
