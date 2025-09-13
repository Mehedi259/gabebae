import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup2_bottom_sheet.dart';
import 'package:MenuSideKick/presentation/screens/profileSetup/profile_setup_widgets/profile_setup_heading2345.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';


class ProfileSetup2Screen extends StatefulWidget {
  const ProfileSetup2Screen({super.key});

  @override
  State<ProfileSetup2Screen> createState() => _ProfileSetup2ScreenState();
}

class _ProfileSetup2ScreenState extends State<ProfileSetup2Screen> {
  final Set<String> selectedFoods = {};

  void _openProfileSetup2BottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProfileSetup2BottomSheet(),
    );
  }

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

              ProfileSetupHeading(
                stepText: "Step 2 of 5",
                progress: 0.4,
                title: "Anything we should avoid for you?",
                subtitle: "We'll keep you safe & worry-free.",
                onBack: () => context.go(RoutePath.profileSetup1.addBasePath),
              ),

              const SizedBox(height: 24),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  buildFoodCard("Nuts", Assets.images.nuts.path),
                  buildFoodCard("Dairy", Assets.images.dairy.path),
                  buildFoodCard("Gluten", Assets.images.gluten.path),
                  buildFoodCard("Shellfish", Assets.images.shellfish.path),
                  buildFoodCard("Egg", Assets.images.egg.path),
                  buildFoodCard(
                    "See More",
                    Assets.images.plus.path,
                    backgroundColor: const Color(0xFFF9FAFB),
                    textColor: const Color(0xFF4B5563),
                    isSeeMore: true,
                    onTap: _openProfileSetup2BottomSheet,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Looks good 😊",
                  onTap: () => context.go(RoutePath.profileSetup3.addBasePath),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFoodCard(
      String title,
      String image, {
        Color backgroundColor = Colors.white,
        Color textColor = Colors.black,
        bool isSeeMore = false,
        VoidCallback? onTap,
      }) {
    final bool isSelected = selectedFoods.contains(title);

    return GestureDetector(
      onTap: () {
        if (isSeeMore && onTap != null) {
          onTap();
        } else {
          setState(() {
            isSelected
                ? selectedFoods.remove(title)
                : selectedFoods.add(title);
          });
        }
      },
      child: Container(
        width: 163,
        height: 128,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFE27B4F), width: 2)
              : Border.all(color: Colors.transparent, width: 0),
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
              color: isSeeMore ? const Color(0xFF4B5563) : null,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isSeeMore ? const Color(0xFF4B5563) : textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
