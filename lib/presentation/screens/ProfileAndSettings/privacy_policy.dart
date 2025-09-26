import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
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
                """Menu Sidekick helps you make more informed food choices by scanning menus, highlighting ingredients, and offering personalized suggestions. This Privacy Policy explains how we collect, use, and share information when you use our mobile application, related websites, and services (collectively, the “Service”).

By using the Service, you agree to this Privacy Policy.""",
              ),

              _buildSectionTitle("1. Information"),
              _buildParagraph(
                """We may collect the following categories of information:

• Account Information: If you create an account, we may collect your name, email, password, and profile settings.
• Profile & Preferences: Diets, allergies, restrictions, and goals you provide to personalize your experience.
• Usage Information: Details about how you interact with the Service, such as menu scans, selections, and app features you use.
• Device & Technical Data: Device type, operating system, IP address, app version, language, time zone, and crash or performance reports.
• Payment & Subscription Info: If you purchase a subscription, Apple App Store or Google Play processes payments; we may receive confirmation of purchase.
• Communications: Information you provide when contacting support, participating in app feedback, or opening our emails. We may track engagement (e.g., whether you opened an email) to improve communications.
• Location (Optional): If enabled, approximate location may be used for regional menu support or localization.""",
              ),

              _buildSectionTitle("2. How We Use Information"),
              _buildParagraph(
                """We use information to:

• Provide and personalize the Service (e.g., apply your filters and show safe/unsafe flags).
• Improve app performance, accuracy, and user experience.
• Respond to questions and provide customer support.
• Send updates, offers, and communications (you may opt out anytime).
• Monitor safety, detect misuse, and protect against fraud or abuse.
• Comply with legal and regulatory obligations.""",
              ),

              _buildSectionTitle("3. How We Share Information"),
              _buildParagraph(
                """We may share information in the following ways:

• Service Providers: With trusted providers who help us operate (e.g., hosting, analytics, crash reporting, customer support).
• App Stores & Payment Platforms: Apple and Google process subscriptions and purchases directly.
• Legal & Safety: To comply with law, legal processes, or protect rights, safety, and integrity.
• Business Transfers: If Menu Sidekick is involved in a merger, acquisition, or sale, information may transfer as part of that transaction. We do not sell personal information.""",
              ),

              _buildSectionTitle("4. Your Choices"),
              _buildParagraph(
                """• Profile Controls: Update your diets, allergies, and preferences in-app.
• Account Management: You may request deletion of your account and data at any time by contacting MenuSidekick@gmail.com.
• Data Portability: Where required by law, you may request a copy of your personal data in a portable format.
• Notifications & Permissions: Manage push notifications and device permissions (location, camera, etc.) through your device settings.
• Email Preferences: You may unsubscribe from marketing emails at any time.""",
              ),

              _buildSectionTitle("5. Data Retention"),
              _buildParagraph(
                "We keep personal data only as long as needed for the purposes described, unless a longer period is required by law. When no longer needed, we delete or de-identify it.",
              ),

              _buildSectionTitle("6. Cookies & Tracking Technologies"),
              _buildParagraph(
                "Our websites and in-app webviews may use cookies, pixels, or similar technologies to enable features, remember preferences, and gather analytics. You can adjust your browser or device settings to block or delete cookies.",
              ),

              _buildSectionTitle("7. Ingredient Data & Feedback"),
              _buildParagraph(
                "Because ingredient information may vary, we allow users to flag or suggest corrections for data accuracy. This feedback helps us improve the Service.",
              ),

              _buildSectionTitle("8. Security"),
              _buildParagraph(
                "We use reasonable technical and organizational safeguards to protect your information. However, no method of storage or transmission is completely secure.",
              ),

              _buildSectionTitle("9. Children’s Privacy"),
              _buildParagraph(
                """• The Service is not directed to children under 13 in the U.S. (or under 16 in certain regions).
• We do not knowingly collect personal information from children. If you believe a child has provided data, contact us and we will delete it.""",
              ),

              _buildSectionTitle("10. International Users"),
              _buildParagraph(
                """Menu Sidekick is based in the United States, and information may be processed there or in other countries.

• EU/UK Users: You may have rights under data protection law, including access, correction, deletion, portability, and objection. We may rely on Standard Contractual Clauses (SCCs) or similar safeguards for cross-border transfers.
• Other Regions: We will respect applicable local data protection laws.
• By using the Service, you consent to your data being transferred to and processed in the U.S. and other countries where our providers operate. Nothing in this Policy limits your consumer protection rights under local law.""",
              ),

              _buildSectionTitle("11. Changes to this Policy"),
              _buildParagraph(
                "We may update this Privacy Policy from time to time. If changes are material, we will make reasonable efforts to notify you (e.g., in-app notice or by email). Continued use after changes means you accept the updated Policy.",
              ),

              _buildSectionTitle("12. Contact Us"),
              _buildParagraph(
                "If you have questions or requests regarding this Privacy Policy, please contact us: Menu Sidekick, LLC\nEmail: MenuSidekick@gmail.com",
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
