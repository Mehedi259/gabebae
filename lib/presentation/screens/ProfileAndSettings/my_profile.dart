import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.home.addBasePath),
        ),
        title: const Text(
          "My Profile",
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildMenuItem(
                icon: Assets.images.editprofile.image(width: 32, height: 32),
                title: "Edit Profile",
                onTap: () => context.go(RoutePath.editProfile.addBasePath),
              ),
              _buildMenuItem(
                icon: Assets.images.accountsettings.image(width: 32, height: 32),
                title: "Account Settings",
                onTap: () => context.go(RoutePath.accountSettings.addBasePath),
              ),
              _buildMenuItem(
                icon: Assets.images.subscriptions.image(width: 32, height: 32),
                title: "Subscriptions",
                onTap: () => context.go(RoutePath.subscription.addBasePath),
              ),
              _buildMenuItem(
                icon: Assets.images.helpSupport.image(width: 32, height: 32),
                title: "Help & Support",
                onTap: () => context.go(RoutePath.helpAndSupport.addBasePath),
              ),
              _buildMenuItem(
                icon: Assets.images.logout.image(width: 32, height: 32),
                title: "Logout",
                color: const Color(0xFF2D6B8F),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Assets.images.av1.image(width: 48, height: 48),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bennie - You",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Active Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.go(RoutePath.switchProfile.addBasePath),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4A261),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              "Switch Profile",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildMenuItem({
    required Widget icon,
    required String title,
    Color color = const Color(0xFFF4A261),
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: icon,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            title != "Logout"
                ? Assets.images.entry.image(width: 32, height: 32)
                : const SizedBox(width: 32, height: 32),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF9F5F0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Do you want to log out?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.go(RoutePath.onBoarding2.addBasePath),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFF4A261)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF4A261),
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.go(RoutePath.myProfile.addBasePath),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A261),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
