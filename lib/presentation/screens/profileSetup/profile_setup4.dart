import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup4_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ProfileSetup4Screen extends StatefulWidget {
  const ProfileSetup4Screen({super.key});

  @override
  State<ProfileSetup4Screen> createState() => _ProfileSetup4ScreenState();
}

class _ProfileSetup4ScreenState extends State<ProfileSetup4Screen> {
  /// State of each toggle
  final Map<String, bool> switches = {
    "Diabetes": false,
    "Hypertension": false,
    "High Cholesterol": false,
    "Celiac Disease": false,
  };

  final List<Map<String, dynamic>> options = [
    {"title": "Diabetes", "image": Assets.images.dairy.path},
    {"title": "Hypertension", "image": Assets.images.gluten.path},
    {"title": "High Cholesterol", "image": Assets.images.nuts.path},
    {"title": "Celiac Disease", "image": Assets.images.soy.path},
    {"title": "See More", "image": Assets.images.plus.path},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Ready to Glow ✨",
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

              /// ===== Header =====
              ProfileSetupHeading(
                stepText: "Step 4 of 5",
                progress: 0.8,
                title: "✨ Here’s the magic list ✨",
                subtitle: "These are all the ingredients we’re watching for you — switch on or off anytime 🌿",
                onBack: () => context.go(RoutePath.profileSetup3.addBasePath),
              ),

              const SizedBox(height: 24),

              /// ===== Health Options =====
              ...List.generate(options.length, (index) {
                final item = options[index];

                if (item["title"] == "See More") {
                  return GestureDetector(
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
                      imagePath: item["image"],
                      isActive: false,
                      onChanged: (_) {},
                      showSwitch: false,
                    ),
                  );
                }

                return _buildHealthCard(
                  title: item["title"],
                  imagePath: item["image"],
                  isActive: switches[item["title"]] ?? false,
                  onChanged: (val) {
                    setState(() {
                      switches[item["title"]!] = val;
                    });
                  },
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

          /// ===== Middle Title =====
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

          /// ===== Right Switch =====
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
                  alignment:
                  isActive ? Alignment.centerRight : Alignment.centerLeft,
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
