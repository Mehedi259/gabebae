import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black87,
        height: 1.6,
      ),
    );
  }

  Widget _buildRich(String bold, String normal) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
        children: [
          TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: normal),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
        title: Text(
          "Terms of Service",
          style: GoogleFonts.poppins(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header Info
              _buildRich("Effective Date: ", "September 22, 2025"),
              _buildRich("Entity: ", "Menu Sidekick, LLC (“Menu Sidekick,” “we,” “us,” or “our”)"),
              _buildRich("Contact: ", "MenuSidekick@gmail.com"),
              _buildRich("Website: ", "MenuSidekick.app"),
              const SizedBox(height: 12),

              _buildParagraph(
                "These Terms of Service (“Terms”) form a legally binding agreement between you and Menu Sidekick regarding your use of our mobile application, related websites, and services (collectively, the “Service”).\n\n"
                    "By clicking “I Accept” or by downloading, installing, accessing, or using the Service, you agree to these Terms and our Privacy Policy. If you do not agree, you may not use the Service.\n",
              ),

              _buildRich("Important Disclaimer: ",
                  "Menu Sidekick is designed to help you make more informed food choices by scanning menus, highlighting ingredients, and offering suggestions. It does not provide medical advice. Always confirm with restaurant staff and consult a qualified professional for health-related concerns.\n"),

              _buildSectionTitle("1. Service Overview"),
              _buildParagraph(
                "Menu Sidekick helps users:\n"
                    "• Scan menus via camera, upload, or text input.\n"
                    "• Apply filters for diets, allergies, and preferences.\n"
                    "• View ingredient tags, safety flags, and suggested modifications.\n"
                    "• Share dining preferences with restaurants via QR codes.\n"
                    "• Receive tips, substitutions, and information through Menu Sidekick AI.\n\n"
                    "The Service is provided for ",
              ),
              _buildRich("informational and wellness purposes only.", ""),

              _buildSectionTitle("2. Eligibility"),
              _buildParagraph(
                "• You must be at least 18 years old to use the Service.\n"
                    "• By using the Service, you confirm that:\n"
                    "(a) you are 18 or older;\n"
                    "(b) you have not been suspended or removed from the Service;\n"
                    "(c) your use complies with all applicable laws.",
              ),

              _buildSectionTitle("3. Accounts"),
              _buildParagraph(
                "• You may need an account to use certain features. Provide accurate information and keep it updated.\n"
                    "• You are responsible for safeguarding your login.\n",
              ),
              _buildRich("Contact: ", "MenuSidekick@gmail.com if you suspect unauthorized use."),

              _buildSectionTitle("4. Payments & Subscriptions"),
              _buildParagraph(
                "• Some features are free; others require a paid subscription.\n"
                    "• Fees will be displayed before purchase.\n"
                    "• Payments are handled by Apple App Store or Google Play.\n"
                    "• Subscriptions auto-renew unless canceled in your device settings.\n"
                    "• Refunds are only provided where required by law.",
              ),

              _buildSectionTitle("5. Intellectual Property & Licenses"),
              _buildRich("• Ownership: ", "All rights, title, and interest in the Service belong to Menu Sidekick, LLC."),
              _buildRich("• License to You: ", "We grant you a limited, non-exclusive, non-transferable, revocable license to use the Service for personal, non-commercial purposes."),
              _buildRich("• User Content: ", "You retain ownership of content you submit but grant us a worldwide, royalty-free license to use it to provide and improve the Service."),
              _buildParagraph("• You may not copy, modify, distribute, reverse-engineer, or create derivative works from the Service."),

              _buildSectionTitle("6. User Content Rules"),
              _buildParagraph(
                "You are solely responsible for content you provide (e.g., preferences, scans, feedback). You agree not to submit content that is:\n"
                    "• False, misleading, or infringing on others’ rights.\n"
                    "• Unlawful, offensive, or harmful.\n"
                    "• Intended to disrupt or damage the Service.\n"
                    "We reserve the right to remove content that violates these Terms.",
              ),

              _buildSectionTitle("7. Prohibited Conduct"),
              _buildParagraph(
                "You agree not to:\n"
                    "• Misuse the Service for illegal or harmful purposes.\n"
                    "• Harass, exploit, or harm others.\n"
                    "• Interfere with security, attempt to reverse-engineer, or disrupt operations.\n"
                    "• Access or collect data in unauthorized ways (e.g., scraping).",
              ),

              _buildSectionTitle("8. Communications & Marketing"),
              _buildParagraph(
                "• By creating an account, you may receive emails or notifications related to the Service.\n"
                    "• We may also send optional marketing messages. You can opt out anytime.\n"
                    "• If you provide a phone number, you may consent to receive SMS/texts. Standard messaging rates apply.",
              ),

              _buildSectionTitle("9. Third-Party Services"),
              _buildParagraph(
                "• Menu Sidekick may link to or rely on third-party services. We are not responsible for their content or practices.\n"
                    "• Payment, analytics, and other features may involve third parties governed by their own terms.",
              ),

              _buildSectionTitle("10. Disclaimers"),
              _buildParagraph(
                "• The Service is provided “AS IS” without warranties.\n"
                    "• We do not guarantee accuracy of ingredient data, menu scans, or suggestions.\n"
                    "• We do not provide medical, dietary, or professional advice.",
              ),

              _buildSectionTitle("11. Limitation of Liability"),
              _buildParagraph(
                "To the maximum extent allowed by law:\n"
                    "• We are not liable for indirect, incidental, or consequential damages.\n"
                    "• Our total liability is limited to the greater of (a) the amount you paid us in the last 12 months, or (b) \$100.",
              ),

              _buildSectionTitle("12. Indemnification"),
              _buildRich("You agree to indemnify and hold harmless Menu Sidekick, LLC, ", "its officers, employees, and affiliates from claims or damages related to your misuse of the Service or violation of these Terms."),

              _buildSectionTitle("13. Dispute Resolution"),
              _buildRich("For U.S. Users\n• Binding Arbitration: ", "Any dispute will be resolved by binding arbitration under the AAA Consumer Rules."),
              _buildRich("• Waiver of Jury Trial: ", "You waive the right to a jury trial."),
              _buildRich("• Waiver of Class Actions: ", "Disputes must be resolved individually."),
              _buildRich("• Small Claims Exception: ", "Eligible claims may be brought in small claims court."),
              _buildRich("• Opt-Out: ", "You may opt out of arbitration within 30 days by emailing MenuSidekick@gmail.com."),
              _buildRich("For Users Outside the U.S.: ", "You may resolve disputes in your local courts. Nothing in these Terms limits your consumer rights."),

              _buildSectionTitle("14. Termination & Changes"),
              _buildParagraph(
                "• We may suspend or terminate your access if you violate these Terms.\n"
                    "• You may stop using the Service at any time.\n"
                    "• We may modify or discontinue parts of the Service at any time.\n"
                    "• We will make reasonable efforts to notify you of material changes. Continued use means acceptance.",
              ),

              _buildSectionTitle("15. Governing Law"),
              _buildParagraph(
                "• For U.S. users, these Terms are governed by the laws of the State of Florida, USA.\n"
                    "• For international users, nothing in these Terms limits your protections under the laws of your country of residence.",
              ),

              _buildSectionTitle("16. Miscellaneous"),
              _buildParagraph(
                "• These Terms are the entire agreement between you and us.\n"
                    "• If any part is unenforceable, the rest remain effective.\n"
                    "• Section titles are for convenience only.",
              ),

              _buildSectionTitle("17. App Store Terms"),
              _buildParagraph(
                "• If downloaded via Apple or Google, you agree to their terms.\n"
                    "• Apple and Google are not responsible for the Service and are third-party beneficiaries of these Terms.",
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
