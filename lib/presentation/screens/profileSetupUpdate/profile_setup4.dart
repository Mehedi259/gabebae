// lib/presentation/screens/profileSetupUpdate/profile_setup4.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/profileSetupUpdate/profile_setup_widgets/profile_setup4_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetupUpdate/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:go_router/go_router.dart';
import '../../../core/controllers/profile_setup_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup4ScreenUpdate extends StatefulWidget {
  const ProfileSetup4ScreenUpdate({super.key});

  @override
  State<ProfileSetup4ScreenUpdate> createState() => _ProfileSetup4ScreenUpdateState();
}

class _ProfileSetup4ScreenUpdateState extends State<ProfileSetup4ScreenUpdate>
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

    _progressAnim = Tween<double>(begin: 0.6, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Generate magic list when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateMagicListIfNeeded();
    });
  }

  Future<void> _generateMagicListIfNeeded() async {
    // Only generate if not already generated and we have selections
    if (profileController.magicList.isEmpty &&
        (profileController.selectedEatingStyles.isNotEmpty ||
            profileController.selectedAllergies.isNotEmpty ||
            profileController.selectedMedicalConditions.isNotEmpty)) {
      await profileController.generateMagicList();
    }
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
        child: Obx(() {
          return profileController.isGeneratingMagicList.value
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
              : CustomButton(
            text: l10n.readyToGlow,
            onTap: () => context.go(RoutePath.profileSetup5Update.addBasePath),
          );
        }),
      ),

      body: SafeArea(
        child: Obx(() {
          if (profileController.isGeneratingMagicList.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Generating your personalized magic list...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (profileController.magicList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No magic list available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileController.generateMagicList(),
                    child: const Text('Generate Magic List'),
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
                      stepText: l10n.step4Of5,
                      progress: _progressAnim.value,
                      title: l10n.magicList,
                      subtitle: l10n.magicListSubtitle,
                      onBack: () => context.go(RoutePath.profileSetup3Update.addBasePath),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Display first 4 magic list items
                ...List.generate(
                  profileController.magicList.length > 4
                      ? 4
                      : profileController.magicList.length,
                      (index) {
                    final item = profileController.magicList[index];

                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final intervalStart = (index * 0.12).clamp(0.0, 1.0);
                        final anim = CurvedAnimation(
                          parent: _controller,
                          curve: Interval(intervalStart, 1.0,
                              curve: Curves.easeOutBack),
                        );

                        return FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.3, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: _buildMagicListCard(
                        title: item,
                      ),
                    );
                  },
                ),

                // See More button if more than 4
                if (profileController.magicList.length > 4)
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
                            begin: const Offset(-0.3, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const ProfileSetup4BottomSheet(),
                        );
                      },
                      child: _buildMagicListCard(
                        title: l10n.seeMore,
                        showSwitch: false,
                        isSpecial: true,
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

  Widget _buildMagicListCard({
    required String title,
    bool showSwitch = true,
    bool isSpecial = false,
  }) {
    return Obx(() {
      final bool isActive = profileController.selectedMagicListItems.contains(title);

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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            if (showSwitch)
              GestureDetector(
                onTap: () => profileController.toggleMagicListItem(title),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
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
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment:
                    isActive ? Alignment.centerRight : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF669A59) : Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: isActive
                            ? [
                          const BoxShadow(
                            color: Color(0x40669A59),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                            : null,
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