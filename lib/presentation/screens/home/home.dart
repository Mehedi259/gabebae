// lib/presentation/screens/home/home.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/presentation/widgets/navigation.dart';
import '../../../core/controllers/home_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import 'home_widgets/history_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  late final HomeController _homeController;

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  void initState() {
    super.initState();
    // Use Get.find if controller already exists, otherwise create new one
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }

    // Reload data when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.refreshHomeData();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go(RoutePath.home.addBasePath);
        break;
      case 1:
        context.go(RoutePath.scanMenu.addBasePath);
        break;
      case 2:
        context.go(RoutePath.askChatBot.addBasePath);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: Obx(() {
          if (_homeController.isLoadingProfile.value &&
              _homeController.activeProfile.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _homeController.refreshHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== Top Header =====
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  /// ===== Dining Profile Card =====
                  _buildDiningProfileCard(context),
                  const SizedBox(height: 24),

                  /// ===== Favorites Section =====
                  _buildFavoritesSection(context),
                  const SizedBox(height: 24),

                  /// ===== Recent Scans Section =====
                  _buildRecentScansSection(context),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ===== Header =====
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = _homeController.activeProfile.value;

    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go(RoutePath.myProfile.addBasePath),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            child: profile?.avatar != null
                ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: profile!.avatar!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person),
              ),
            )
                : const Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            profile?.profileName ?? l10n.hiUser,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF154452),
            ),
          ),
        ),
      ],
    );
  }

  /// ===== Dining Profile Card =====
  Widget _buildDiningProfileCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = _homeController.activeProfile.value;

    if (profile == null) {
      return const SizedBox.shrink();
    }

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
              Text(
                l10n.yourDiningProfile,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.go(RoutePath.profileSetup1Update.addBasePath),
                child: Assets.icons.edit.svg(width: 20, height: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Diet Section
          if (profile.eatingStyle.isNotEmpty) ...[
            Text(l10n.diet,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.eatingStyle.map((style) {
                final iconUrl = _homeController.getEatingStyleIcon(style.name);
                return _buildChipWithNetworkIcon(
                  style.name,
                  iconUrl,
                  const Color(0x1A6CA865),
                  const Color(0xFF6CA865),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          /// Allergies Section
          if (profile.allergies.isNotEmpty) ...[
            Text(l10n.allergies,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.allergies.map((allergy) {
                final iconUrl = _homeController.getAllergyIcon(allergy);
                return _buildChipWithNetworkIcon(
                  allergy,
                  iconUrl,
                  const Color(0xFFFEF2F2),
                  const Color(0xFFDC2626),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          /// Health Section
          if (profile.medicalConditions.isNotEmpty) ...[
            Text(l10n.health,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.medicalConditions.map((condition) {
                final iconUrl = _homeController.getMedicalConditionIcon(condition);
                return _buildChipWithNetworkIcon(
                  condition,
                  iconUrl,
                  const Color(0x1AE2B94C),
                  const Color(0xFFE2B94C),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          GestureDetector(
            onTap: () => context.go(RoutePath.myQrCode.addBasePath),
            child: Text(
              l10n.shareQrCode,
              style: const TextStyle(
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

  /// ===== Chip with Network Icon =====
  Widget _buildChipWithNetworkIcon(
      String text, String? iconUrl, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconUrl != null)
            CachedNetworkImage(
              imageUrl: iconUrl,
              width: 16,
              height: 16,
              placeholder: (context, url) =>
              const SizedBox(width: 16, height: 16),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 16),
            )
          else
            const Icon(Icons.circle, size: 16),
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

  /// ===== Favorites Section =====
  Widget _buildFavoritesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final favorites = _homeController.myPlateFavorites;

      return Column(
        children: [
          _buildSectionHeader(
            title: l10n.yourFavorites,
            onSeeAllTap: () => context.go(RoutePath.activity.addBasePath),
          ),
          const SizedBox(height: 16),
          if (_homeController.isLoadingFavorites.value)
            const Center(child: CircularProgressIndicator())
          else if (favorites.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No favorites yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return _buildFoodCard(favorite.mealName, favorite.imageUrl);
                },
              ),
            ),
        ],
      );
    });
  }

  /// ===== Recent Scans Section =====
  Widget _buildRecentScansSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final scans = _homeController.scannedDocuments;

      return Column(
        children: [
          _buildSectionHeader(
            title: l10n.recentScans,
            onSeeAllTap: () => context.go(RoutePath.activity.addBasePath),
          ),
          const SizedBox(height: 16),
          if (_homeController.isLoadingScans.value)
            const Center(child: CircularProgressIndicator())
          else if (scans.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No recent scans',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...scans.map((scan) => HistoryCard(
              title: scan.aiReply.documentTitle,
              date: "${l10n.scannedOn} ${scan.uploadedAt}",
              safeItems: scan.aiReply.totalSafeItems,
              notSafeItems: scan.aiReply.totalUnsafeItems,
              imagePath: scan.fileUrl,
              isNetworkImage: true,
            )),
        ],
      );
    });
  }

  /// ===== Section Header =====
  Widget _buildSectionHeader(
      {required String title, required VoidCallback onSeeAllTap}) {
    final l10n = AppLocalizations.of(context)!;

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
          child: Text(
            l10n.seeAll,
            style: const TextStyle(
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
  Widget _buildFoodCard(String title, String imageUrl) {
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
              color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4)),
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 112,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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