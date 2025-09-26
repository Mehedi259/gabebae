import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup3_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup3Screen extends StatefulWidget {
  const ProfileSetup3Screen({super.key});

  @override
  State<ProfileSetup3Screen> createState() => _ProfileSetup3ScreenState();
}

class _ProfileSetup3ScreenState extends State<ProfileSetup3Screen>
    with SingleTickerProviderStateMixin {
  /// State of each toggle
  final Map<String, bool> switches = {
    "Diabetes": false,
    "Hypertension": false,
    "High Cholesterol": false,
    "Celiac Disease": false,
  };

  final List<Map<String, dynamic>> options = [
    {
      "title": "Diabetes",
      "subtitle": "Type 1 or Type 2",
      "image": Assets.images.diabetes.path,
    },
    {
      "title": "Hypertension",
      "subtitle": "High blood pressure",
      "image": Assets.images.hypertension.path,
    },
    {
      "title": "High Cholesterol",
      "subtitle": "Elevated lipid levels",
      "image": Assets.images.highCholesterol.path,
    },
    {
      "title": "Celiac Disease",
      "subtitle": "Gluten intolerance",
      "image": Assets.images.celiacDisease.path,
    },
    {
      "title": "See More",
      "subtitle": "",
      "image": Assets.images.plus.path,
    },
  ];

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

    // Progress animation: 0.4 to 0.6 (Step 3)
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "All set here 💛",
          onTap: () => context.go(RoutePath.profileSetup4.addBasePath),
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
                    stepText: "Step 3 of 5",
                    progress: _progressAnim.value,
                    title: "Should we watch out for any health needs?",
                    subtitle: "We've got your back, always ✨",
                    onBack: () => context.go(RoutePath.profileSetup2.addBasePath),
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
                  child: item["title"] == "See More"
                      ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ProfileSetup3BottomSheet(),
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

              const SizedBox(height: 100), // for bottom button spacing
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
          /// ===== Left: Icon =====
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

          /// ===== Middle: Texts =====
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

          /// ===== Right: Animated Switch =====
          if (showSwitch)
            GestureDetector(
              onTap: () => onChanged(!isActive),
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
  }
}