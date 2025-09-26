import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup2_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

/// ===============================================================
/// Profile Setup - Step 2 (Animated)
/// ===============================================================
class ProfileSetup2Screen extends StatefulWidget {
  const ProfileSetup2Screen({super.key});

  @override
  State<ProfileSetup2Screen> createState() => _ProfileSetup2ScreenState();
}

class _ProfileSetup2ScreenState extends State<ProfileSetup2Screen>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedFoods = {};

  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _progressAnim = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Custom animated bottom sheet
  void _openProfileSetup2BottomSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BottomSheet",
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, _, __) {
        return const Align(
          alignment: Alignment.bottomCenter,
          child: ProfileSetup2BottomSheet(),
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
          text: "Looks good 😊",
          onTap: () => context.go(RoutePath.profileSetup3.addBasePath),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              /// ---------- STEP INDICATOR ----------
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  return ProfileSetupHeading(
                    stepText: "Step 2 of 5",
                    progress: _progressAnim.value,
                    title: "Anything we should avoid for you?",
                    subtitle: "We'll keep you safe & worry-free.",
                    onBack: () =>
                        context.go(RoutePath.profileSetup1.addBasePath),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// ---------- Animated FOOD CARDS ----------
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(_foods.length, (index) {
                  final item = _foods[index];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final intervalStart = (index * 0.1).clamp(0.0, 1.0);
                      final anim = CurvedAnimation(
                        parent: _controller,
                        curve: Interval(intervalStart, 1.0,
                            curve: Curves.easeOutBack),
                      );

                      return FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      );
                    },
                    child: buildFoodCard(
                      title: item["title"]!,
                      image: item["image"]!,
                      isSeeMore: item["isSeeMore"] == "true",
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Food Card
  Widget buildFoodCard({
    required String title,
    required String image,
    bool isSeeMore = false,
  }) {
    final bool isSelected = selectedFoods.contains(title);

    return GestureDetector(
      onTap: () {
        if (isSeeMore) {
          _openProfileSetup2BottomSheet();
        } else {
          setState(() {
            isSelected
                ? selectedFoods.remove(title)
                : selectedFoods.add(title);
          });
        }
      },
      child: Container(
        width: 145,
        height: 128,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSeeMore ? const Color(0xFFF9FAFB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFE27B4F), width: 2)
              : Border.all(color: Colors.transparent, width: 0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 44,
              height: 44,
              color: isSeeMore ? const Color(0xFF4B5563) : null,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isSeeMore ? const Color(0xFF4B5563) : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Dummy Foods List
final List<Map<String, String>> _foods = [
  {"title": "Nuts", "image": Assets.images.nuts.path},
  {"title": "Dairy", "image": Assets.images.dairy.path},
  {"title": "Gluten", "image": Assets.images.gluten.path},
  {"title": "Shellfish", "image": Assets.images.shellfish.path},
  {"title": "Egg", "image": Assets.images.egg.path},
  {
    "title": "See More",
    "image": Assets.images.plus.path,
    "isSeeMore": "true",
  },
];
