import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class PrivacyPolicyScreenAuth extends StatefulWidget {
  const PrivacyPolicyScreenAuth({super.key});

  @override
  State<PrivacyPolicyScreenAuth> createState() => _PrivacyPolicyScreenAuthState();
}

class _PrivacyPolicyScreenAuthState extends State<PrivacyPolicyScreenAuth> {
  bool agreeTerms = false;
  bool agreePrivacy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.continue_,
          onTap: () => context.go(RoutePath.onBoarding2.addBasePath),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.onBoarding2.addBasePath),
        ),
        title: Text(
          l10n.privacyPolicy,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yourSafetyPriority,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.safetyMessage,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeTerms,
                        onChanged: (val) => setState(() => agreeTerms = val ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: AppColors.black000000,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: l10n.agreeToTerms,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: l10n.termsOfService,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: agreePrivacy,
                        onChanged: (val) => setState(() => agreePrivacy = val ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: AppColors.black000000,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: l10n.agreeToPrivacy,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: l10n.privacyPolicy,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}