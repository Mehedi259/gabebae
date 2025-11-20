// lib/presentation/screens/profileSetupUpdate/profile_setup2.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/utils/app_colors/app_colors.dart';
import 'package:MenuSideKick/l10n/app_localizations.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup2_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import '../../../core/controllers/profile_setup_controller.dart';

class ProfileSetup2ScreenUpdate extends StatefulWidget {
  const ProfileSetup2ScreenUpdate({super.key});

  @override
  State<ProfileSetup2ScreenUpdate> createState() => _ProfileSetup2ScreenUpdateState();
}

class _ProfileSetup2ScreenUpdateState extends State<ProfileSetup2ScreenUpdate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  final ProfileSetupController profileController = Get.find<ProfileSetupController>();

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

  void _openProfileSetup2BottomSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BottomSheet",
      barrierColor: Colors.black.withOpacity(0.4),
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

  Widget buildFoodCard({
    required String title,
    required String image,
    bool isSeeMore = false,
    bool isNetworkImage = false,
  }) {
    return Obx(() {
      final bool isSelected = profileController.selectedAllergies.contains(title);

      return GestureDetector(
        onTap: () {
          if (isSeeMore) {
            _openProfileSetup2BottomSheet();
          } else {
            profileController.toggleAllergy(title);
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
                : Border.all(color: Colors.transparent),
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
              isNetworkImage
                  ? Image.network(
                image,
                width: 44,
                height: 44,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.no_food, size: 44);
                },
              )
                  : Image.asset(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.looksGood,
          onTap: () => context.go(RoutePath.profileSetup3Update.addBasePath),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoadingAllergies.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileController.allergies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No allergies available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileController.fetchAllergies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (context, _) {
                    return ProfileSetupHeading(
                      stepText: l10n.step2Of5,
                      progress: _progressAnim.value,
                      title: l10n.anythingToAvoid,
                      subtitle: l10n.keepYouSafe,
                      onBack: () =>
                          context.go(RoutePath.profileSetup1.addBasePath),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...List.generate(
                      profileController.allergies.length > 5
                          ? 5
                          : profileController.allergies.length,
                          (index) {
                        final allergy = profileController.allergies[index];
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final intervalStart = (index * 0.1).clamp(0.0, 1.0);
                            final anim = CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                intervalStart,
                                1.0,
                                curve: Curves.easeOutBack,
                              ),
                            );
                            return FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(scale: anim, child: child),
                            );
                          },
                          child: buildFoodCard(
                            title: allergy.allergyName,
                            image: allergy.allergyIcon,
                            isNetworkImage: true,
                          ),
                        );
                      },
                    ),

                    if (profileController.allergies.length > 5)
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final anim = CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
                          );
                          return FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(scale: anim, child: child),
                          );
                        },
                        child: buildFoodCard(
                          title: l10n.seeMore,
                          image: Assets.images.plus.path,
                          isSeeMore: true,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}