// lib/presentation/screens/profileSetup/profile_setup1.dart
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup1_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile_setup_controller.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../l10n/app_localizations.dart';
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
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  final ProfileSetupController profileController = Get.put(ProfileSetupController());

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

  void _openAnimatedBottomSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BottomSheet",
      barrierColor: Colors.black54,
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

  void _handleNextButton() {
    // Validate: Check if at least 1 eating style is selected
    if (profileController.selectedEatingStyles.isEmpty) {
      Get.snackbar(
        '',
        'Please select at least 1 eating style',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFC4C02),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // If validation passes, navigate to next screen
    context.go(RoutePath.profileSetup2.addBasePath);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.nextUp,
          onTap: _handleNextButton,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoadingEatingStyles.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileController.eatingStyles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No eating styles available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileController.fetchEatingStyles(),
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
                    return ProfileHeading1(
                      stepText: l10n.step1Of5,
                      progress: _progressAnim.value,
                      title: l10n.whatsYourEatingStyle,
                      subtitle: l10n.pickDiet,
                    );
                  },
                ),
                const SizedBox(height: 24),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...List.generate(
                      profileController.eatingStyles.length > 5
                          ? 5
                          : profileController.eatingStyles.length,
                          (index) {
                        final eatingStyle = profileController.eatingStyles[index];
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
                                  title: eatingStyle.eatingStyleName,
                                  subtitle: eatingStyle.details ?? '',
                                  image: eatingStyle.eatingStyleIcon,
                                  isNetworkImage: true,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    if (profileController.eatingStyles.length > 5)
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final animation = CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
                          );
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: buildFoodCard(
                                title: l10n.seeMore,
                                subtitle: "",
                                image: Assets.images.plus.path,
                                isSeeMore: true,
                              ),
                            ),
                          );
                        },
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

  Widget buildFoodCard({
    required String title,
    required String subtitle,
    required String image,
    bool isSeeMore = false,
    bool isNetworkImage = false,
  }) {
    return Obx(() {
      final bool isSelected = profileController.selectedEatingStyles.containsKey(title);

      return GestureDetector(
        onTap: () {
          if (isSeeMore) {
            _openAnimatedBottomSheet();
          } else {
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
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 145,
          height: 150,
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
              isNetworkImage
                  ? Image.network(
                image,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.restaurant, size: 40);
                },
              )
                  : Image.asset(
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
    });
  }
}