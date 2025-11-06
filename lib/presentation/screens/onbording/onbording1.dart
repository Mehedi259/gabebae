import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/controllers/language_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class OnBoarding1Screen extends StatefulWidget {
  const OnBoarding1Screen({super.key});

  @override
  State<OnBoarding1Screen> createState() => _OnBoarding1ScreenState();
}

class _OnBoarding1ScreenState extends State<OnBoarding1Screen> {
  final LanguageController _langController = Get.put(LanguageController());

  final List<Map<String, String>> _languages = [
    {"flag": "🇺🇸", "code": "en", "title": "English"},
    {"flag": "🇪🇸", "code": "es", "title": "Español"},
    {"flag": "🇫🇷", "code": "fr", "title": "Français"},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.letsBegin,
          onTap: () => context.go(RoutePath.onBoarding2.addBasePath),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Language Dropdown
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 16, right: 24),
                width: 80,
                height: 32,
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
                child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _langController.currentLanguageCode.toUpperCase(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontSize: 12,
                    ),
                    items: _languages.map((lang) {
                      return DropdownMenuItem<String>(
                        value: lang["code"]!.toUpperCase(),
                        child: Row(
                          children: [
                            Text(lang["flag"]!, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(lang["code"]!.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _langController.changeLanguage(value.toLowerCase());
                      }
                    },
                  ),
                )),
              ),
            ),

            /// Body Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            Text(
                              l10n.menuSidekick,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.heyThere,
                                  style: const TextStyle(
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
                            Text(
                              l10n.welcomeMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}