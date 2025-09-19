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
  String _selectedFlag = "🇺🇸";

  void _openLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Language",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLangTile("🇺🇸", "EN", "English"),
                _buildLangTile("🇪🇸", "ES", "Español"),
                _buildLangTile("🇫🇷", "FR", "Français"),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLangTile(String flag, String code, String title) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: _selectedLang == code
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        setState(() {
          _selectedLang = code;
          _selectedFlag = flag;
        });
        Navigator.pop(context);
      },
    );
  }

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
        child: Stack(
          children: [
            /// ===== Main Content =====
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60), // Language button height spacing

                /// ============= Top Container (Image + Title) =============
                SizedBox(
                  width: double.infinity,
                  height: 276,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Splash style image
                      SizedBox(
                        width: 190,
                        height: 160,
                        child: Assets.images.splash.image(fit: BoxFit.contain),
                      ),

                      const SizedBox(height: 20),

                      /// Title Text
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

            /// ========= Top Bar with Language Button =========
            Positioned(
              top: 20,
              right: 16,
              child: GestureDetector(
                onTap: _openLanguageSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selectedFlag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        _selectedLang,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
