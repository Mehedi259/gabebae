import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/subscription/widget/sucess_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String selectedPlan = "Yearly"; // ✅ Default selected plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Start My 3-Day Free Trial ✨",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SuccessPopup(
                  onContinue: () {
                    Navigator.pop(context);
                  },
                ),
              );
            }

        ),
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              "🌿 Start your 3-day FREE trial to continue ✨",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 24),
            Assets.images.plan.image(width: double.infinity, height: 338),
            const SizedBox(height: 16),
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
      leading: IconButton(
        icon: Assets.icons.back.svg(width: 16, height: 18),
        onPressed: () => context.go(RoutePath.myProfile.addBasePath),
      ),
      title: const Text(
        "Subscriptions",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildSubscriptionOptions() {
    return Column(
      children: [
        _buildSubscriptionOption(
          title: 'Monthly',
          price: '\$4.99/mo',
          isSelected: selectedPlan == "Monthly",
          showFreeTag: selectedPlan == "Monthly", // ✅ Only show when selected
          onTap: () => setState(() => selectedPlan = "Monthly"),
        ),
        const SizedBox(height: 12),
        _buildSubscriptionOption(
          title: 'Yearly',
          price: '\$24.99/mo \n(\$29.99/year)',
          isSelected: selectedPlan == "Yearly",
          showFreeTag: selectedPlan == "Yearly", // ✅ Only show when selected
          onTap: () => setState(() => selectedPlan = "Yearly"),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '💛 No payment due today.',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color(0xFF444444),
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
    required bool showFreeTag,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 336,
            height: 120,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0x1AD97D54) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFD97D54) : const Color(0x8888A096),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x23000000),
                  blurRadius: 25,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title + Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF444444),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFFD97D54)
                            : const Color(0xFF88A096),
                      ),
                    ),
                  ],
                ),

                // Custom Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFD97D54) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD97D54)
                          : const Color(0xFF88A096),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
                ),
              ],
            ),
          ),

          // ✅ Show Free Tag Only When Selected
          if (showFreeTag)
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC97B63),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  "3 Days Free",
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStartTrialButton() {
    return Column(
      children: [
        Text(
          "3 days free, then \$29.99 per year. Cancel anytime during trial.",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: const Color(0xff88a096),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
