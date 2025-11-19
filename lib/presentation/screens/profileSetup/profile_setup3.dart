// lib/presentation/screens/profileSetup/profile_setup3.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup3_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../core/controllers/profile_setup_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup3Screen extends StatefulWidget {
  const ProfileSetup3Screen({super.key});

  @override
  State<ProfileSetup3Screen> createState() => _ProfileSetup3ScreenState();
}

class _ProfileSetup3ScreenState extends State<ProfileSetup3Screen>
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

    _progressAnim = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.allSetHere,
          onTap: () => context.go(RoutePath.profileSetup4.addBasePath),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoadingMedicalConditions.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileController.medicalConditions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No medical conditions available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileController.fetchMedicalConditions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (context, _) {
                    return ProfileSetupHeading(
                      stepText: l10n.step3Of5,
                      progress: _progressAnim.value,
                      title: l10n.watchOutHealthNeeds,
                      subtitle: l10n.gotYourBack,
                      onBack: () => context.go(RoutePath.profileSetup2.addBasePath),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Display first 4 medical conditions
                ...List.generate(
                  profileController.medicalConditions.length > 4
                      ? 4
                      : profileController.medicalConditions.length,
                      (index) {
                    final condition = profileController.medicalConditions[index];

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
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        );
                      },
                      child: _buildHealthCard(
                        title: condition.medicalConditionName,
                        subtitle: condition.medicalDescription,
                        imagePath: condition.medicalConditionIcon,
                        isNetworkImage: true,
                      ),
                    );
                  },
                ),

                // See More button if more than 4
                if (profileController.medicalConditions.length > 4)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final anim = CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
                      );

                      return FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const ProfileSetup3BottomSheet(),
                        );
                      },
                      child: _buildHealthCard(
                        title: l10n.seeMore,
                        subtitle: '',
                        imagePath: Assets.images.plus.path,
                        showSwitch: false,
                      ),
                    ),
                  ),

                const SizedBox(height: 100),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required String imagePath,
    bool showSwitch = true,
    bool isNetworkImage = false,
  }) {
    return Obx(() {
      final bool isActive = profileController.selectedMedicalConditions.contains(title);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F5),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                child: isNetworkImage
                    ? Image.network(
                  imagePath,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.health_and_safety, size: 24);
                  },
                )
                    : Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ]
                ],
              ),
            ),

            if (showSwitch)
              GestureDetector(
                onTap: () => profileController.toggleMedicalCondition(title),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0x80669A59)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    alignment: isActive
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF669A59) : Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}