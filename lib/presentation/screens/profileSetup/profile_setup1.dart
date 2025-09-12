import 'package:flutter/material.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import 'custom_hedding_widget/profile_heading1.dart';


class ProfileSetup1Screen extends StatefulWidget {
  const ProfileSetup1Screen({super.key});

  @override
  State<ProfileSetup1Screen> createState() => _ProfileSetup1ScreenState();
}

class _ProfileSetup1ScreenState extends State<ProfileSetup1Screen> {
  String? selectedFood; // track selected card

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

              // ====== Top Heading + Progress ======
              const ProfileHeading1(
                stepText: "Step 1 of 5",
                progress: 0.2,
                title: "What's your eating style?",
                subtitle: "Pick one or more that tells like you.",
              ),

              const SizedBox(height: 24),

              // ====== Food/Diet Cards ======
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  buildFoodCard(
                    title: "Vegan",
                    subtitle: "Plant-based only",
                    image: Assets.images.vegan.path,
                  ),
                  buildFoodCard(
                    title: "Pescatarian",
                    subtitle: "Fish & vegetables",
                    image: Assets.images.pescatarian.path,
                  ),
                  buildFoodCard(
                    title: "Keto",
                    subtitle: "Low carb, high fat",
                    image: Assets.images.keto.path,
                  ),
                  buildFoodCard(
                    title: "Paleo",
                    subtitle: "Whole foods only",
                    image: Assets.images.paleo.path,
                  ),
                  buildFoodCard(
                    title: "Gluten-Free",
                    subtitle: "No gluten",
                    image: Assets.images.glutenFree.path,
                  ),
                  buildFoodCard(
                    title: "See More",
                    subtitle: "",
                    image: Assets.images.plus.path,
                    isSeeMore: true,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ====== Bottom Next Button ======
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Next Up ✨",
                  onTap: () {
                    // Navigate to next onboarding step
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFoodCard({
    required String title,
    required String subtitle,
    required String image,
    bool isSeeMore = false,
  }) {
    final bool isSelected = selectedFood == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFood = title;
        });
      },
      child: Container(
        width: 155,
        height: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFC4C02)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 40,
              height: 40,
              color: isSeeMore ? const Color(0xFF6B7280) : null,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: isSeeMore ? const Color(0xFF4B5563) : Colors.black,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
