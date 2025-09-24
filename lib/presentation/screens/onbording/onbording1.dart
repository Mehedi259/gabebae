import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class OnBoarding1Screen extends StatefulWidget {
  const OnBoarding1Screen({super.key});

  @override
  State<OnBoarding1Screen> createState() => _OnBoarding1ScreenState();
}

class _OnBoarding1ScreenState extends State<OnBoarding1Screen> {
  String _selectedLang = "EN";

  final List<Map<String, String>> _languages = [
    {"flag": "🇺🇸", "code": "EN", "title": "English"},
    {"flag": "🇪🇸", "code": "ES", "title": "Español"},
    {"flag": "🇫🇷", "code": "FR", "title": "Français"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Let’s Begin ✨",
          onTap: () => context.go(RoutePath.onBoarding2.addBasePath),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              /// ===== Main Content =====
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  /// ============= Top Container (Image + Title) =============
                  SizedBox(
                    width: double.infinity,
                    height: 276,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 214,
                          height: 180,
                          child: Assets.images.splash.image(fit: BoxFit.cover),
                        ),
                        const Text(
                          "Menu\nSidekick",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "EB Garamond",
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                            height: 1.0,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ============= Middle Container (Subtitle + Description) =============
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hey there, beautiful soul",
                              style: TextStyle(
                                fontFamily: "EB Garamond",
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                height: 1.25,
                                color: Color(0xFFE27B4F),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Assets.images.flower.image(width: 24, height: 24),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Welcome to Menu Sidekick!\n"
                              "Your pocket-friendly foodie guide\n"
                              "that makes eating out simple,\n"
                              "safe, and joyful.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// ========= Top Bar with Language Dropdown =========
              Positioned(
                top: 20,
                right: 24,
                child: Container(
                  width: 79.72,
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLang,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        fontSize: 12,
                      ),
                      items: _languages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang["code"],
                          child: Row(
                            children: [
                              Text(lang["flag"]!,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(lang["code"]!),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final selected = _languages
                              .firstWhere((lang) => lang["code"] == value);
                          setState(() {
                            _selectedLang = selected["code"]!;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
