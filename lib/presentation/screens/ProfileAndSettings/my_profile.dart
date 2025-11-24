// lib/presentation/screens/ProfileAndSettings/my_profile.dart

import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.home.addBasePath),
        ),
        title: Text(
          l10n.myProfile,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (_profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_profileController.activeProfile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No active profile found'),
                ElevatedButton(
                  onPressed: () => _profileController.fetchActiveProfile(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(l10n),
                const SizedBox(height: 24),
                _buildMenuItem(
                  icon: Assets.images.editprofile.image(width: 32, height: 32),
                  title: l10n.editProfile,
                  onTap: () => context.go(RoutePath.editProfile.addBasePath),
                ),
                _buildMenuItem(
                  icon: Assets.images.accountsettings.image(width: 32, height: 32),
                  title: l10n.accountSettings,
                  onTap: () => context.go(RoutePath.accountSettings.addBasePath),
                ),
                _buildMenuItem(
                  icon: Assets.images.subscriptions.image(width: 32, height: 32),
                  title: l10n.subscriptions,
                  onTap: () => context.go(RoutePath.subscription.addBasePath),
                ),
                _buildMenuItem(
                  icon: Assets.images.helpSupport.image(width: 32, height: 32),
                  title: l10n.helpSupport,
                  onTap: () => context.go(RoutePath.helpAndSupport.addBasePath),
                ),
                _buildMenuItem(
                  icon: Assets.images.logout.image(width: 32, height: 32),
                  title: l10n.logout,
                  color: const Color(0xFF2D6B8F),
                  onTap: () => _showLogoutDialog(context, l10n),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n) {
    return Obx(() {
      final profile = _profileController.activeProfile.value;

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
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profile?.avatar != null
                      ? NetworkImage(profile!.avatar!)
                      : null,
                  child: profile?.avatar == null
                      ? ClipOval(
                    child: Assets.images.av1.image(width: 48, height: 48),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.profileName ?? "Loading...",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      l10n.activeProfile,
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
                l10n.switchProfile,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    Color color = const Color(0xFFF4A261),
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;

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
            title != l10n.logout
                ? Assets.images.entry.image(width: 32, height: 32)
                : const SizedBox(width: 32, height: 32),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF9F5F0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.logoutConfirmation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Logout and clear token
                    await _profileController.logout();

                    // Navigate to onboarding
                    if (context.mounted) {
                      context.go(RoutePath.onBoarding2.addBasePath);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFF4A261)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.yes,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF4A261),
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A261),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.no,
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