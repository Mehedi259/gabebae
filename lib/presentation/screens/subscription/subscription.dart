import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildTrialBanner(),
            const SizedBox(height: 24),
            _buildTrialTimeline(),
            const SizedBox(height: 24),
            _buildSubscriptionOptions(),
            const SizedBox(height: 16),
            _buildStartTrialButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Assets.images.dibbaback.image(width: 40, height: 40),
            onPressed: () => context.go(RoutePath.myProfile.addBasePath),
          ),
          Text(
            "💸 Subscriptions",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
          Container(width: 75),
        ],
      ),
    );
  }

  Widget _buildTrialBanner() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9EB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.eco, color: Color(0xFF65A30D), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Start your 3-day FREE trial to continue ✨",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineItem(
          icon: Icons.lock,
          color: const Color(0xFFFDAA5D),
          day: 'Day 1',
          description:
          'Unlock all the app\'s foodie magic — scan menus, see your safe dishes, get tips & tweaks',
        ),
        _buildTimelineConnector(),
        _buildTimelineItem(
          icon: Icons.notifications,
          color: const Color(0xFFFDBA74),
          day: 'Day 2',
          description:
          'We\'ll send you a gentle reminder that your trial is ending soon 🌸',
        ),
        _buildTimelineConnector(),
        _buildTimelineItem(
          icon: Icons.check_circle_outline,
          color: const Color(0xFF65A30D),
          day: 'Day 3',
          description:
          'Your subscription begins — cancel anytime before then if it\'s not your vibe ✨',
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color color,
    required String day,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 11.0),
      width: 2,
      height: 20,
      color: const Color(0xFFE5E7EB),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Column(
      children: [
        _buildSubscriptionOption(
          title: 'Monthly',
          price: '\$4.99/mo',
          isSelected: true,
          icon: Icons.eco,
        ),
        const SizedBox(height: 12),
        _buildSubscriptionOption(
          title: 'Yearly',
          price: '\$24.99/mo (\$29.99/year)',
          isSelected: false,
          icon: Icons.star,
          isHighlighted: true,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '💛 No payment due today.',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFFFDAA5D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionOption({
    required String title,
    required String price,
    required bool isSelected,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFDEDD8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: isSelected ? const Color(0xFF65A30D) : Colors.grey,
                  size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isHighlighted)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFDAA5D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '3 Days Free',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            )
          else
            Radio<bool>(
              value: isSelected,
              groupValue: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF65A30D),
            ),
        ],
      ),
    );
  }

  Widget _buildStartTrialButton() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE27B4F),
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Start My 3-Day Free Trial ✨",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "3 days free, then \$29.99 per year. Cancel anytime during trial.",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
