// lib/presentation/screens/profileSetupUpdate/profile_setup5.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import 'package:go_router/go_router.dart';
import '../../../core/controllers/profile_setup_controller.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';

class ProfileSetup5ScreenUpdate extends StatefulWidget {
  const ProfileSetup5ScreenUpdate({super.key});

  @override
  State<ProfileSetup5ScreenUpdate> createState() => _ProfileSetup5ScreenUpdateState();
}

class _ProfileSetup5ScreenUpdateState extends State<ProfileSetup5ScreenUpdate>
    with SingleTickerProviderStateMixin {
  final ProfileSetupController profileController = Get.find<ProfileSetupController>();

  late AnimationController _controller;
  late Animation<double> _progressAnim;
  late List<Animation<double>> _sectionAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progressAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _sectionAnimations = [
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
      ),
    ];

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ এখানে UPDATE method call করছি
  Future<void> _handleUpdateProfile() async {
    // Validate before updating
    if (profileController.nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (profileController.selectedAvatar.value == null ||
        profileController.selectedAvatar.value!.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an avatar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set default date of birth if not set
    if (profileController.dateOfBirth.value == null) {
      profileController.dateOfBirth.value = DateTime(2000, 1, 1);
    }

    // ✅ updateProfile() call করছি createProfile() এর বদলে
    final success = await profileController.updateProfile();
    if (success && mounted) {
      context.go(RoutePath.home.addBasePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  return ProfileSetupHeading(
                    stepText: l10n.step5Of5,
                    progress: _progressAnim.value,
                    title: l10n.allSetLovely,
                    subtitle: l10n.diningReadyMessage,
                    onBack: () => context.go(RoutePath.profileSetup4.addBasePath),
                  );
                },
              ),
              const SizedBox(height: 14),

              /// Name Input Section
              AnimatedBuilder(
                animation: _sectionAnimations[0],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _sectionAnimations[0],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_sectionAnimations[0]),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.whatToCallYou,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.grey, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: profileController.nameController,
                              decoration: InputDecoration(
                                hintText: l10n.enterYourName,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFADAEBC),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              /// Avatar Selection Section
              AnimatedBuilder(
                animation: _sectionAnimations[1],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _sectionAnimations[1],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-0.3, 0),
                        end: Offset.zero,
                      ).animate(_sectionAnimations[1]),
                      child: child,
                    ),
                  );
                },
                child: Obx(() {
                  if (profileController.isLoadingAvatars.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (profileController.avatars.isEmpty) {
                    return Column(
                      children: [
                        const Text('No avatars available'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => profileController.fetchAvatars(),
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.chooseAvatar,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          profileController.avatars.length,
                              (index) {
                            final avatar = profileController.avatars[index];
                            return Obx(() {
                              final isSelected = profileController.selectedAvatar.value == avatar.avatarIcon;

                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final avatarDelay = 0.4 + (index * 0.05);
                                  final avatarAnim = CurvedAnimation(
                                    parent: _controller,
                                    curve: Interval(
                                      avatarDelay.clamp(0.0, 0.9),
                                      1.0,
                                      curve: Curves.easeOutBack,
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: avatarAnim,
                                    child: ScaleTransition(
                                      scale: Tween<double>(begin: 0.6, end: 1.0)
                                          .animate(avatarAnim),
                                      child: child,
                                    ),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () => profileController.selectAvatar(avatar.avatarIcon),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFE27B4F)
                                            : Colors.transparent,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                        const BoxShadow(
                                          color: Color(0x40E27B4F),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                          : null,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        avatar.avatarIcon,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.person, size: 40),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 10),

              /// Upload Section
              AnimatedBuilder(
                animation: _sectionAnimations[2],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _sectionAnimations[2],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.3, 0),
                        end: Offset.zero,
                      ).animate(_sectionAnimations[2]),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        l10n.or,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          l10n.uploadPhoto,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              /// Buttons Section - ✅ isUpdatingProfile ব্যবহার করছি
              AnimatedBuilder(
                animation: _sectionAnimations[3],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _sectionAnimations[3],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_sectionAnimations[3]),
                      child: child,
                    ),
                  );
                },
                child: Obx(() {
                  final isUpdating = profileController.isUpdatingProfile.value;

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            side: const BorderSide(color: Color(0xFFE27B4F)),
                          ),
                          onPressed: isUpdating
                              ? null
                              : () {
                            // Reset and go back to step 1
                            profileController.resetSelections();
                            context.go(RoutePath.profileSetup1.addBasePath);
                          },
                          child: Text(
                            l10n.addAnotherProfile,
                            style: TextStyle(
                              color: isUpdating ? Colors.grey : const Color(0xFFE27B4F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: Text(
                          l10n.or,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: isUpdating
                            ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE27B4F),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                            : CustomButton(
                          text: l10n.letsEat,
                          onTap: _handleUpdateProfile, // ✅ Update method call
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}