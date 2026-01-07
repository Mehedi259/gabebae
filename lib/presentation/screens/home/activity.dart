// lib/presentation/screens/home/activity.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/home_controller.dart';
import '../home/home_widgets/history_card.dart';

class YourActivityScreen extends StatefulWidget {
  const YourActivityScreen({super.key});

  @override
  State<YourActivityScreen> createState() => _YourActivityScreenState();
}

class _YourActivityScreenState extends State<YourActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Get existing controller or create new one
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }

    // Reload data when activity screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    await Future.wait([
      _homeController.reloadFavorites(),
      _homeController.reloadScans(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// ===== Header Section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Assets.images.dibbaback.image(width: 40, height: 40),
                    onPressed: () {
                      // Refresh home data before going back
                      _homeController.refreshHomeData();
                      context.go(RoutePath.home.addBasePath);
                    },
                  ),
                  Expanded(
                    child: Text(
                      l10n.yourActivity,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23333C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // spacer for alignment
                ],
              ),
            ),

            /// ===== Tab Bar Section =====
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFE56A2E),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFE56A2E),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bookmark, size: 20),
                      const SizedBox(width: 6),
                      Text(l10n.favorites),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 20),
                      const SizedBox(width: 6),
                      Text(l10n.history),
                    ],
                  ),
                ),
              ],
            ),

            /// ===== Tab Content Section =====
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// ---- Favorites Tab ----
                  _buildFavoritesTab(context),

                  /// ---- History Tab ----
                  _buildHistoryTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== Favorites Tab =====
  Widget _buildFavoritesTab(BuildContext context) {
    return Obx(() {
      if (_homeController.isLoadingFavorites.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final favorites = _homeController.myPlateFavorites;

      if (favorites.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start adding your favorite meals!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => _homeController.reloadFavorites(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return _buildFavoriteCard(
                title: favorite.mealName,
                imageUrl: favorite.imageUrl,
              );
            },
          ),
        ),
      );
    });
  }

  /// ===== History Tab =====
  Widget _buildHistoryTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      if (_homeController.isLoadingScans.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final scans = _homeController.scannedDocuments;

      if (scans.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No scan history yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start scanning menus to see your history!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => _homeController.reloadScans(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: scans.map((scan) {
              return HistoryCard(
                title: scan.aiReply.documentTitle,
                date: "${l10n.scannedOn} ${scan.uploadedAt}",
                safeItems: scan.aiReply.totalSafeItems,
                notSafeItems: scan.aiReply.totalUnsafeItems,
                imagePath: scan.fileUrl,
                isNetworkImage: true,
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  /// ===== Favorite Card Widget =====
  Widget _buildFavoriteCard({
    required String title,
    required String imageUrl,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Food Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.star, color: Colors.amber, size: 18),
                ),
              ),
            ],
          ),

          /// Title + Tag
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 62,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x1A6CA865),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.healthy,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6CA865),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}