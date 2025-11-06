import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../home/home_widgets/history_card.dart';

class YourActivityScreen extends StatefulWidget {
  const YourActivityScreen({super.key});

  @override
  State<YourActivityScreen> createState() => _YourActivityScreenState();
}

class _YourActivityScreenState extends State<YourActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    onPressed: () => context.go(RoutePath.home.addBasePath),
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
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return _buildFavoriteCard();
                          },
                        ),
                      ],
                    ),
                  ),

                  /// ---- History Tab ----
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        HistoryCard(
                          title: l10n.bellaVistalItalian,
                          date: "${l10n.scannedOn} Aug 25, 10:32 AM",
                          safeItems: 3,
                          notSafeItems: 2,
                          imagePath: Assets.images.bellaVistalItalian.path,
                        ),
                        const SizedBox(height: 12),
                        HistoryCard(
                          title: l10n.oceanBreezeSeafood,
                          date: "${l10n.scannedOn} Aug 24, 07:15 AM",
                          safeItems: 5,
                          notSafeItems: 0,
                          imagePath: Assets.images.oceanBreezeSeafood.path,
                        ),
                        const SizedBox(height: 12),
                        HistoryCard(
                          title: l10n.burgerPlace,
                          date: "${l10n.scannedOn} Aug 23, 1:45 AM",
                          safeItems: 3,
                          notSafeItems: 4,
                          imagePath: Assets.images.bellaVistalItalian.path,
                        ),
                        const SizedBox(height: 12),
                        HistoryCard(
                          title: l10n.goldenDragonAsian,
                          date: "${l10n.scannedOn} Aug 22, 10:32 AM",
                          safeItems: 3,
                          notSafeItems: 0,
                          imagePath: Assets.images.oceanBreezeSeafood.path,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== Favorite Card Widget =====
  Widget _buildFavoriteCard() {
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
                child: Image.asset(
                  Assets.images.avocadoToast.path,
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
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
                  l10n.grilledSalmon,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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