import 'package:flutter/material.dart';

import '../../../core/custom_assets/assets.gen.dart';


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
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== Header Section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      "Your Activity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance spacing
                ],
              ),
            ),

            /// ===== Tab Bar Section =====
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFE56A2E),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFE56A2E),
              tabs: const [
                Tab(icon: Icon(Icons.bookmark), text: "Favorites"),
                Tab(icon: Icon(Icons.history), text: "History"),
              ],
            ),

            /// ===== Tab Content Section =====
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// ---- Favorites Grid ----
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
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
                  ),

                  /// ---- History List ----
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildHistoryCard(
                          image: Assets.images.bellaVistalItalian.path,
                          title: "Bella Vistal Italian",
                          date: "Scanned On Aug 25, 10:32 AM",
                          safe: "3 Safe Items",
                          unsafe: "2 Not Safe",
                        ),
                        _buildHistoryCard(
                          image: Assets.images.oceanBreezeSeafood.path,
                          title: "Ocean Breeze Seafood",
                          date: "Scanned On Aug 24, 07:15 AM",
                          safe: "5 Safe Items",
                        ),
                        _buildHistoryCard(
                          image: Assets.images.bellaVistalItalian.path,
                          title: "Burger Place",
                          date: "Scanned On Aug 23, 1:45 AM",
                          safe: "3 Safe Items",
                          unsafe: "4 Not Safe",
                        ),
                        _buildHistoryCard(
                          image: Assets.images.oceanBreezeSeafood.path,
                          title: "Golden Dragon Asian",
                          date: "Scanned On Aug 22, 10:32 AM",
                          safe: "3 Safe Items",
                          unknown: "2 Unknown",
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
          // Food Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              Assets.images.avocadoToast.path,
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
          ),

          // Title + Tag
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Grilled Salmon",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Healthy",
                    style: TextStyle(
                        fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===== History Card Widget =====
  Widget _buildHistoryCard({
    required String image,
    required String title,
    required String date,
    required String safe,
    String? unsafe,
    String? unknown,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, height: 60, width: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildTag(safe, Colors.green),
                    if (unsafe != null) ...[
                      const SizedBox(width: 6),
                      _buildTag(unsafe, Colors.red),
                    ],
                    if (unknown != null) ...[
                      const SizedBox(width: 6),
                      _buildTag(unknown, Colors.orange),
                    ],
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ===== Status Tag Widget =====
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12)),
    );
  }
}
