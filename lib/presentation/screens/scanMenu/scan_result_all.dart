// lib/presentation/screens/scanMenu/scan_result_all.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/controllers/chat_controller.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/scan_menu_controller.dart';
import '../../../global/model/scan_menu_model.dart';

class MealResultsScreen extends StatefulWidget {
  const MealResultsScreen({super.key});

  @override
  State<MealResultsScreen> createState() => _MealResultsScreenState();
}

class _MealResultsScreenState extends State<MealResultsScreen> {
  final ScanMenuController _scanController = Get.find<ScanMenuController>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ---------- FIXED HEADER ----------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(l10n),
      ),

      /// ---------- SCROLLABLE BODY ----------
      body: Obx(() {
        if (_scanController.isScanning.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_scanController.hasScanResult.value ||
            _scanController.scanResult.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No scan results available',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(RoutePath.scanMenu.addBasePath),
                  child: const Text('Scan Again'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildFilterTabs(l10n),
              const SizedBox(height: 8),
              _buildALaCarteButton(
                l10n,
                onTap: () =>
                    context.go(RoutePath.scanResultBuildMyPlate.addBasePath),
              ),
              const SizedBox(height: 12),
              _buildCardsView(l10n),
            ],
          ),
        );
      }),

      /// ---------- FIXED BOTTOM BUTTONS ----------
      bottomNavigationBar: _buildBottomButtons(l10n),
    );
  }

  /// -------------------- HEADER --------------------
  Widget _buildHeader(AppLocalizations l10n) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Assets.images.dibbaback.image(width: 40, height: 40),
            onPressed: () => context.go(RoutePath.scanMenu.addBasePath),
          ),
          Text(
            l10n.yourMealResults,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
          Obx(() {
            final stats = _scanController.statistics;
            return Container(
              width: 75,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${stats['total']}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  Text('Items',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 10)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// -------------------- FILTER TABS --------------------
  Widget _buildFilterTabs(AppLocalizations l10n) {
    return Obx(() {
      final stats = _scanController.statistics;
      final selectedFilter = _scanController.selectedFilter.value;

      return SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tabButton(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.blueright.image(width: 14, height: 14),
                  const SizedBox(width: 4),
                  Text('${l10n.safe} (${stats['safe']})'),
                ],
              ),
              'safe',
              Colors.green,
              selectedFilter,
            ),
            const SizedBox(width: 8),
            _tabButton(
              Text('${l10n.modify} (${stats['modify']})'),
              'modify',
              Colors.orange,
              selectedFilter,
            ),
            const SizedBox(width: 8),
            _tabButton(
              Text('${l10n.avoid} (${stats['avoid']})'),
              'avoid',
              Colors.red,
              selectedFilter,
            ),
          ],
        ),
      );
    });
  }

  /// -------------------- TAB BUTTON --------------------
  Widget _tabButton(
      Widget child, String filter, Color color, String selectedFilter) {
    final bool isActive = selectedFilter == filter;
    return GestureDetector(
      onTap: () => _scanController.changeFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 34,
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: color),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isActive ? Colors.white : color,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// -------------------- A La Carte Button --------------------
  Widget _buildALaCarteButton(AppLocalizations l10n,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 352,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF60A5FA),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 3), blurRadius: 6)
          ],
        ),
        child: Center(
          child: Text(
            l10n.alaCarteMode,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------- CARD SECTION --------------------
  Widget _buildCardsView(AppLocalizations l10n) {
    return Obx(() {
      final filteredItems = _scanController.filteredFoodItems;

      if (filteredItems.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'No items in this category',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      }

      return Column(
        children: filteredItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildCard(l10n, index: index, foodItem: item);
        }).toList(),
      );
    });
  }

  /// -------------------- CARD WIDGET --------------------
  Widget _buildCard(
      AppLocalizations l10n, {
        required int index,
        required FoodItem foodItem,
      }) {
    return Obx(() {
      final isTipsVisible = _scanController.getTipsVisibility(index);

      return Container(
        width: 352,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(foodItem.foodTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      if (foodItem.frenchName.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(foodItem.frenchName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(foodItem.statusIcon,
                    color: foodItem.statusColor, size: 24),
              ],
            ),
            const SizedBox(height: 8),

            /// INGREDIENT TAGS
            if (foodItem.ingredientsMarks.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: foodItem.ingredientsMarks
                    .take(5)
                    .map((ingredient) => _buildIngredientTag(ingredient))
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],

            /// MESSAGE BOX (AI Recommendations)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: foodItem.messageBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(foodItem.aiRecommendations,
                  style:
                  GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
            ),

            const SizedBox(height: 12),

            /// ✅ Tips Section
            GestureDetector(
              onTap: () => _scanController.toggleTips(index),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    l10n.tips,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isTipsVisible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.green,
                  )
                ],
              ),
            ),
            if (isTipsVisible && foodItem.tips.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  foodItem.tips,
                  style:
                  GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Build ingredient tag
  Widget _buildIngredientTag(IngredientMark ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ingredient.tagColor,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        ingredient.ingredient,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: ingredient.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// -------------------- BOTTOM BUTTONS --------------------
  Widget _buildBottomButtons(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE27B4F),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              shadowColor: Colors.black,
              elevation: 6,
            ),
            onPressed: () async {
              // ✅ Create new conversation and navigate
              final chatController = Get.find<ChatController>();
              await chatController.createNewConversation();
              if (context.mounted) {
                context.go(RoutePath.askChatBot.addBasePath);
              }
            },
            icon: const Icon(Icons.chat, color: Colors.white),
            label: Text(
              l10n.askAiChatAboutThis,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),

          /// ✅ QR CODE ICON ADDED
          OutlinedButton.icon(
            icon: const Icon(Icons.qr_code, color: Color(0xFFE27B4F)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: Color(0xFFE27B4F), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onPressed: () => context.go(RoutePath.myQrCode.addBasePath),
            label: Text(
              l10n.shareQrCode,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFFE27B4F)),
            ),
          ),
        ],
      ),
    );
  }
}