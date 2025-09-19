import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/widgets/navigation.dart';
import 'home_widgets/history_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go(RoutePath.home.addBasePath); // ✅ Fixed
        break;
      case 1:
        context.go(RoutePath.scanMenu.addBasePath); // ✅ Fixed
        break;
      case 2:
        context.go(RoutePath.askChatBot.addBasePath); // ✅ Fixed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),

      /// ===== Custom Bottom Navigation Bar =====
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap, // ✅ Added
      ),

      /// ===== Body =====
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Top Header =====
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(RoutePath.myProfile.addBasePath),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          Assets.images.av1.path,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Hi, Switee",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF154452),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text("✨ 1"),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.go(RoutePath.myProfile.addBasePath),
                    child: Assets.icons.orangeprofile
                        .svg(width: 20, height: 20),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ===== Dining Profile Card =====
              _buildDiningProfileCard(context),

              const SizedBox(height: 24),

              /// ===== Favorites Section =====
              _buildSectionHeader(
                title: "Your Favorites",
                onSeeAllTap: () =>
                    context.go(RoutePath.activity.addBasePath),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFoodCard(
                        "Avocado Toast", Assets.images.avocadoToast.path),
                    _buildFoodCard(
                        "Quinoa Bowl", Assets.images.quinoaBowl.path),
                    _buildFoodCard("Green Smoothie",
                        Assets.images.greenSmoothie.path),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ===== Recent Scans Section =====
              _buildSectionHeader(
                title: "Recent Scans",
                onSeeAllTap: () =>
                    context.go(RoutePath.activity.addBasePath),
              ),
              const SizedBox(height: 16),
              HistoryCard(
                title: "Bella Vistal Italian",
                date: "Scanned On Aug 25, 10:32 AM",
                safeItems: 3,
                notSafeItems: 2,
                imagePath: Assets.images.bellaVistalItalian.path,
              ),
              HistoryCard(
                title: "Ocean Breeze Seafood",
                date: "Scanned On Aug 24, 07:15 AM",
                safeItems: 5,
                notSafeItems: 0,
                imagePath: Assets.images.oceanBreezeSeafood.path,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== Dining Profile Card =====
  Widget _buildDiningProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "✨ Your Dining Profile ✨",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              GestureDetector(
                onTap: () => context.go(RoutePath.profileSetup1.addBasePath),
                child: Assets.icons.edit.svg(width: 20, height: 20),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Diet",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildChipWithIcon("Vegan", Assets.images.vegan.path,
                  const Color(0x1A6CA865), const Color(0xFF6CA865)),
              _buildChipWithIcon("Dairy-Free", Assets.images.dairy.path,
                  const Color(0x1A3B8F9D), const Color(0xFF3B8F9D)),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Allergies",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildChipWithIcon("Peanuts", Assets.images.nuts.path,
                  const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
              _buildChipWithIcon("Shellfish", Assets.images.shellfish.path,
                  const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Health",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 8),
          _buildChipWithIcon("Diabetic", Assets.images.diabetes.path,
              const Color(0x1AE2B94C), const Color(0xFFE2B94C)),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => context.go(RoutePath.myQrCode.addBasePath),
            child: const Text(
              "Share Your Diet via QR Code",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE27B4F),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== Chip with Icon =====
  static Widget _buildChipWithIcon(
      String text, String iconPath, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// ===== Section Header with See All Click =====
  Widget _buildSectionHeader(
      {required String title, required VoidCallback onSeeAllTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF23333C),
          ),
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: const Text(
            "See All",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE6764E),
            ),
          ),
        ),
      ],
    );
  }

  /// ===== Food Card =====
  Widget _buildFoodCard(String title, String imagePath) {
    return Container(
      width: 128,
      height: 118,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4)),
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(imagePath,
                width: 112, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF23333C),
            ),
          ),
        ],
      ),
    );
  }
}
