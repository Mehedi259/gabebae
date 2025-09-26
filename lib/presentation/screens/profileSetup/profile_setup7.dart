import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class PrivacyPolicyScreenPs extends StatefulWidget {
  const PrivacyPolicyScreenPs({super.key});

  @override
  State<PrivacyPolicyScreenPs> createState() => _PrivacyPolicyScreenPsState();
}

class _PrivacyPolicyScreenPsState extends State<PrivacyPolicyScreenPs> {
  bool agreeToTerms = false;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: agreeToTerms
                ? () => context.go(RoutePath.home.addBasePath)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: agreeToTerms
                  ? const Color(0xFFE85A2B)
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: agreeToTerms ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: agreeToTerms ? Colors.white : Colors.grey.shade600,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Custom Header with shield icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 25),
              child: Row(
                children: [
                  // Shield Icon
                  Container(

                    child: Assets.images.shild.image(width: 37, height: 37),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Title with sparkles
                    Text(
                      "✨ Your Safety is Our Priority ✨",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Content
                    Text(
                      "Menu Sidekick helps guide your food choices but it may not always be perfect. Ingredients and recipes can change anytime.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF1F2937),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Warning section
                    Text(
                      "⚠️ Always double-check ⚠️",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 17),

                    Text(
                      "Ask your server or restaurant before ordering, especially if you have allergies. This app is for information only 💛 -not medical advice or a guarantee of safety.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Ready to get started section
                    Text(
                      "Ready to get started?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Single checkbox with terms and privacy policy
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          onChanged: (val) => setState(() => agreeToTerms = val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: const Color(0xFF1F2937),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I agree to Menu Sidekick\'s ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => _launchURL('https://menusidekick.app/terms'),
                                        child: Text(
                                          "Terms of Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: const Color(0xFF1F2937),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => _launchURL('https://menusidekick.app/privacy'),
                                        child: Text(
                                          "Privacy Policy",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: const Color(0xFF1F2937),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '. I understand that I should always verify ingredient and allergen information, especially if I have a serious food allergy. Any disputes shall be resolved through binding arbitration.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative version without external URLs (if you don't want to add url_launcher dependency)
class PrivacyPolicyScreenPsSimple extends StatefulWidget {
  const PrivacyPolicyScreenPsSimple({super.key});

  @override
  State<PrivacyPolicyScreenPsSimple> createState() => _PrivacyPolicyScreenPsSimpleState();
}

class _PrivacyPolicyScreenPsSimpleState extends State<PrivacyPolicyScreenPsSimple> {
  bool agreeToTerms = false;

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terms of Service"),
        content: const SingleChildScrollView(
          child: Text("Terms of Service content will be displayed here..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const SingleChildScrollView(
          child: Text("Privacy Policy content will be displayed here..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: agreeToTerms
                ? () => context.go(RoutePath.home.addBasePath)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: agreeToTerms
                  ? const Color(0xFFE85A2B)
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: agreeToTerms ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: agreeToTerms ? Colors.white : Colors.grey.shade600,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "✨ Your Safety is Our Priority ✨",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Menu Sidekick helps guide your food choices but it may not always be perfect. Ingredients and recipes can change anytime.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "⚠️ Always double-check ⚠️",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Ask your server or restaurant before ordering, especially if you have allergies. This app is for information only 💛 -not medical advice or a guarantee of safety.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Ready to get started?",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          onChanged: (val) => setState(() => agreeToTerms = val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: const Color(0xFF1F2937),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I agree to "Menu Sidekick\'s" ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: _showTermsDialog,
                                        child: Text(
                                          "Terms of Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: const Color(0xFF1F2937),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: _showPrivacyDialog,
                                        child: Text(
                                          "Privacy Policy",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: const Color(0xFF1F2937),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '. I understand that I should always verify ingredient and allergen information, especially if I have a serious food allergy. Any disputes shall be resolved through binding arbitration.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}