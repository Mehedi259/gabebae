import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup4_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup4Screen extends StatefulWidget {
  const ProfileSetup4Screen({super.key});

  @override
  State<ProfileSetup4Screen> createState() => _ProfileSetup4ScreenState();
}

class _ProfileSetup4ScreenState extends State<ProfileSetup4Screen>
    with SingleTickerProviderStateMixin {
  /// State of each toggle
  late Map<String, bool> switches;

  // Animation Controller
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Progress animation: 0.6 to 0.8 (Step 4)
    _progressAnim = Tween<double>(begin: 0.6, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;

    // Initialize switches with localized keys
    switches = {
      l10n.diabetes: false,
      l10n.hypertension: false,
      l10n.highCholesterol: false,
      l10n.celiacDisease: false,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> options = [
      {
        "title": l10n.diabetes,
        "subtitle": l10n.type1OrType2,
        "image": Assets.images.dairy.path
      },
      {
        "title": l10n.hypertension,
        "subtitle": l10n.highBloodPressure,
        "image": Assets.images.gluten.path
      },
      {
        "title": l10n.highCholesterol,
        "subtitle": l10n.elevatedLipidLevels,
        "image": Assets.images.nuts.path
      },
      {
        "title": l10n.celiacDisease,
        "subtitle": l10n.glutenIntolerance,
        "image": Assets.images.soy.path
      },
      {
        "title": l10n.seeMore,
        "subtitle": "",
        "image": Assets.images.plus.path
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.readyToGlow,
          onTap: () => context.go(RoutePath.profileSetup5.addBasePath),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              /// ===== Animated Header =====
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  return ProfileSetupHeading(
                    stepText: l10n.step4Of5,
                    progress: _progressAnim.value,
                    title: l10n.magicList,
                    subtitle: l10n.magicListSubtitle,
                    onBack: () => context.go(RoutePath.profileSetup3.addBasePath),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// ===== Animated Health Options =====
              ...List.generate(options.length, (index) {
                final item = options[index];

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
                          begin: const Offset(-0.3, 0), // Left to right slide
                          end: Offset.zero,
                        ).animate(anim),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: item["title"] == l10n.seeMore
                      ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ProfileSetup4BottomSheet(),
                      );
                    },
                    child: _buildHealthCard(
                      title: item["title"],
                      subtitle: item["subtitle"],
                      imagePath: item["image"],
                      isActive: false,
                      onChanged: (_) {},
                      showSwitch: false,
                    ),
                  )
                      : _buildHealthCard(
                    title: item["title"],
                    subtitle: item["subtitle"],
                    imagePath: item["image"],
                    isActive: switches[item["title"]] ?? false,
                    onChanged: (val) {
                      setState(() {
                        switches[item["title"]!] = val;
                      });
                    },
                  ),
                );
              }),

              const SizedBox(height: 100), // bottom padding for button
            ],
          ),
        ),
      ),
    );
  }

  /// ===================================================
  /// Health Option Card Widget with Animated Switch
  /// ===================================================
  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isActive,
    required ValueChanged<bool> onChanged,
    bool showSwitch = true,
  }) {
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
          /// ===== Left Icon =====
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F5),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// ===== Middle Title & Subtitle =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// ===== Right Animated Switch =====
          if (showSwitch)
            GestureDetector(
              onTap: () => onChanged(!isActive),
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
  }
}