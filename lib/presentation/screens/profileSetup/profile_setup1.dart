import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup1_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import 'profile_setup_widgets/profile_setup1_heading.dart';
import 'profile_setup_widgets/profile_setup1_balance_controller_popup.dart';

class ProfileSetup1Screen extends StatefulWidget {
  const ProfileSetup1Screen({super.key});

  @override
  State<ProfileSetup1Screen> createState() => _ProfileSetup1ScreenState();
}

class _ProfileSetup1ScreenState extends State<ProfileSetup1Screen>
    with SingleTickerProviderStateMixin {
  final List<String> selectedFoods = []; // multiple selected cards
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _progressAnim = Tween<double>(begin: 0, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ==================================================
  /// Open Animated Bottom Sheet (ProfileSetup2 Style)
  /// ==================================================
  void _openAnimatedBottomSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BottomSheet",
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, _, __) {
        return const Align(
          alignment: Alignment.bottomCenter,
          child: ProfileSetup1BottomSheet(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Next Up ✨",
          onTap: () => context.go(RoutePath.profileSetup2.addBasePath),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              /// ===== Heading + Progress =====
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  return ProfileHeading1(
                    stepText: "Step 1 of 5",
                    progress: _progressAnim.value,
                    title: "What's your eating style?",
                    subtitle: "Pick one or more diet that sounds like you",
                  );
                },
              ),

              const SizedBox(height: 24),

              /// ===== Food Cards =====
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(_foods.length, (index) {
                  final item = _foods[index];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final intervalStart = (index * 0.1).clamp(0.0, 1.0);
                      final animation = CurvedAnimation(
                        parent: _controller,
                        curve: Interval(intervalStart, 1.0,
                            curve: Curves.easeOutBack),
                      );

                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: buildFoodCard(
                            title: item["title"]!,
                            subtitle: item["subtitle"]!,
                            image: item["image"]!,
                            isSeeMore: item["isSeeMore"] == "true",
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =======================================================
  /// Build Food Card
  /// =======================================================
  Widget buildFoodCard({
    required String title,
    required String subtitle,
    required String image,
    bool isSeeMore = false,
  }) {
    final bool isSelected = selectedFoods.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSeeMore) {
            /// 👉 Animated Bottom Sheet Style
            _openAnimatedBottomSheet();
          } else {
            if (isSelected) {
              selectedFoods.remove(title);
            } else {
              selectedFoods.add(title);

              /// Show balance popup animation
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
                      child: const Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(24),
                        child: ProfileSetup1BalanceControllerPopup(),
                      ),
                    ),
                  );
                },
              );
            }
          }
        });
      },
      child: Container(
        width: 145,
        height: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFC4C02)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 40,
              height: 40,
              color: isSeeMore ? const Color(0xFF6B7280) : null,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: isSeeMore ? const Color(0xFF4B5563) : Colors.black,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Dummy Food List
/// ============================================
final List<Map<String, String>> _foods = [
  {
    "title": "Vegan",
    "subtitle": "Plant-based only",
    "image": Assets.images.vegan.path,
  },
  {
    "title": "Pescatarian",
    "subtitle": "Fish & vegetables",
    "image": Assets.images.pescatarian.path,
  },
  {
    "title": "Keto",
    "subtitle": "Low carb, high fat",
    "image": Assets.images.keto.path,
  },
  {
    "title": "Paleo",
    "subtitle": "Whole foods only",
    "image": Assets.images.paleo.path,
  },
  {
    "title": "Gluten-Free",
    "subtitle": "No gluten",
    "image": Assets.images.glutenFree.path,
  },
  {
    "title": "See More",
    "subtitle": "",
    "image": Assets.images.plus.path,
    "isSeeMore": "true",
  },
];
