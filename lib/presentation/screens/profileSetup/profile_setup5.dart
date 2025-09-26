import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:MenuSideKick/presentation/widgets/custom_bottons/custom_button/button.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class ProfileSetup5Screen extends StatefulWidget {
  const ProfileSetup5Screen({super.key});

  @override
  State<ProfileSetup5Screen> createState() => _ProfileSetup5ScreenState();
}

class _ProfileSetup5ScreenState extends State<ProfileSetup5Screen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();

  /// Avatars - mix of SVG & PNG supported
  final List<dynamic> avatars = [
    Assets.images.avt1, // SVG
    Assets.images.avt2,
    Assets.images.avt3,
    Assets.images.avt4,
    Assets.images.avt5,
    Assets.images.avt6,
    Assets.images.avt7,
    Assets.images.avt8,
  ];

  int? selectedIndex; // Which avatar is selected

  // Animation Controller
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

    // Progress animation: 0.8 to 1.0 (Step 5 - Final)
    _progressAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Create animations for different sections
    _sectionAnimations = [
      // Name section (0.1s - 0.6s)
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutBack),
      ),
      // Avatar section (0.3s - 0.8s)
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
      // Upload button (0.5s - 0.9s)
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutBack),
      ),
      // Bottom buttons (0.7s - 1.0s)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Animated Step Heading
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  return ProfileSetupHeading(
                    stepText: "Step 5 of 5",
                    progress: _progressAnim.value,
                    title: "🌸 All set, lovely!",
                    subtitle:
                    "Your dining sidekick is ready to watch out for you. Just tell us your name and choose an avatar that makes you smile ✨",
                    onBack: () => context.go(RoutePath.profileSetup4.addBasePath),
                  );
                },
              ),
              const SizedBox(height: 14),

              /// Animated Name Input Section
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
                    const Text(
                      "🌸 What should we call you?",
                      style: TextStyle(
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
                              controller: nameController,
                              decoration: const InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: TextStyle(
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

              /// Animated Avatar Selection Section
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose Avatar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Animated Avatar Grid
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      children: List.generate(avatars.length, (index) {
                        final isSelected = selectedIndex == index;
                        final avatar = avatars[index];

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
                            onTap: () => setState(() => selectedIndex = index),
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
                                child: avatar is SvgGenImage
                                    ? avatar.svg(
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                                    : (avatar is AssetGenImage
                                    ? Image.asset(
                                  avatar.path,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                                    : const SizedBox()),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              /// Animated Upload Section
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
                    const Center(
                      child: Text(
                        "or",
                        style: TextStyle(
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
                      child: const Center(
                        child: Text(
                          "Upload a Photo",
                          style: TextStyle(
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

              /// Animated Buttons Section
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
                child: Column(
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
                        onPressed: () =>
                            context.go(RoutePath.profileSetup1.addBasePath),
                        child: const Text(
                          "+ Add Another Profile",
                          style: TextStyle(
                            color: Color(0xFFE27B4F),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Center(
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Let's Eat 🌿",
                        onTap: () =>
                            context.go(RoutePath.profileSetup6.addBasePath),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}