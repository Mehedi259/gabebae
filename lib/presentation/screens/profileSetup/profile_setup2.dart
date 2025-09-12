import 'package:flutter/material.dart';
import 'package:gabebae/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import 'custom_hedding_widget/profile_setup_hedding.dart';

/// =======================================================
/// Profile Setup Step 2 Screen
/// =======================================================
class ProfileSetup2Screen extends StatelessWidget {
  const ProfileSetup2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              /// ==================== TOP HEADING ====================
              const ProfileSetupHeading(
                stepText: "Step 2 of 5",
                progress: 0.4, // 40% filled
                title: "Anything we should avoid for you?",
                subtitle: "We'll keep you safe & worry-free.",
              ),

              const SizedBox(height: 24),

              /// ==================== FOOD CARDS ====================
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  FoodCard(
                    title: "Nuts",
                    image: Assets.images.nuts.path,
                  ),
                  FoodCard(
                    title: "Dairy",
                    image: Assets.images.dairy.path,
                  ),
                  FoodCard(
                    title: "Gluten",
                    image: Assets.images.gluten.path,
                  ),
                  FoodCard(
                    title: "Shellfish",
                    image: Assets.images.shellfish.path,
                  ),
                  FoodCard(
                    title: "Egg",
                    image: Assets.images.egg.path,
                  ),
                  FoodCard(
                    title: "See More",
                    image: Assets.images.plus.path,
                    backgroundColor: const Color(0xFFF9FAFB),
                    borderColor: const Color(0xFFD1D5DB),
                    textColor: const Color(0xFF4B5563),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// ==================== BOTTOM BUTTON ====================
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    text: "Next Up ✨",
                    onTap: () =>
                        context.go(RoutePath.onBoarding2.addBasePath),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==================== FOOD CARD WIDGET ====================
class FoodCard extends StatelessWidget {
  final String title;
  final String image;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const FoodCard({
    super.key,
    required this.title,
    required this.image,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 163,
      height: 128,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 44,
            height: 44,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
