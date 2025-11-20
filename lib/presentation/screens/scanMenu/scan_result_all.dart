//lib/presentation/screens/scanMenu/scan_result_all.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';

/// Enum for tab states
enum MealTab { all, safe, modify, avoid }

class MealResultsScreen extends StatefulWidget {
  const MealResultsScreen({super.key});

  @override
  State<MealResultsScreen> createState() => _MealResultsScreenState();
}

class _MealResultsScreenState extends State<MealResultsScreen> {
  MealTab selectedTab = MealTab.all; // ✅ Default: show all
  final Set<int> favoriteCards = {}; // ✅ Track favorite cards

  final Map<int, bool> tipsVisibility = {};

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
      body: SingleChildScrollView(
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
      ),

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
          Container(
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
                Text(l10n.quickPdfView.split('\n')[0],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 12)),
                Text(l10n.quickPdfView.split('\n')[1],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------- FILTER TABS --------------------
  Widget _buildFilterTabs(AppLocalizations l10n) {
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
                Text(l10n.safe),
              ],
            ),
            MealTab.safe,
            Colors.green,
          ),
          const SizedBox(width: 8),
          _tabButton(
            Text(l10n.modify),
            MealTab.modify,
            Colors.orange,
          ),
          const SizedBox(width: 8),
          _tabButton(
            Text(l10n.avoid),
            MealTab.avoid,
            Colors.red,
          ),
        ],
      ),
    );
  }

  /// -------------------- TAB BUTTON --------------------
  Widget _tabButton(Widget child, MealTab tab, Color color) {
    final bool isActive = selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tab),
      child: Container(
        width: 112,
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
  Widget _buildALaCarteButton(AppLocalizations l10n, {required VoidCallback onTap}) {
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
            BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 6)
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
    List<Widget> cards = [];

    if (selectedTab == MealTab.all || selectedTab == MealTab.safe) {
      cards.addAll([
        _buildCard(
          l10n,
          index: 0,
          title: l10n.grilledChickenSalad,
          subtitle: l10n.grilledChickenSaladSubtitle,
          statusIcon: Icons.check_circle,
          statusColor: Colors.green,
          tags: [l10n.tagGlutenFree, l10n.tagDairyFree],
          message: l10n.alignedAndGlowing,
          messageColor: const Color(0xFFF0FDF4),
          tipMessage: l10n.tipOliveOil,
        ),
        _buildCard(
          l10n,
          index: 2,
          title: l10n.quinoaBuddha,
          subtitle: l10n.quinoaBuddhaSubtitle,
          statusIcon: Icons.check_circle,
          statusColor: Colors.green,
          tags: [l10n.tagVegan, l10n.tagHighProtein],
          message: l10n.perfectPowerBowl,
          messageColor: const Color(0xFFF0FDF4),
          tipMessage: l10n.tipOliveOil,
        ),
      ]);
    }
    if (selectedTab == MealTab.all || selectedTab == MealTab.modify) {
      cards.addAll([
        _buildCard(
          l10n,
          index: 1,
          title: l10n.vegetableStirFry,
          subtitle: l10n.vegetableStirFrySubtitle,
          statusIcon: Icons.warning_amber_rounded,
          statusColor: Colors.orange,
          tags: [l10n.tagVegan, l10n.tagSpicy],
          message: l10n.almostSafeTweak,
          messageColor: const Color(0x33FFCA28),
          tipMessage: l10n.tipOliveOil,
        ),
        _buildCard(
          l10n,
          index: 3,
          title: l10n.paneerTikka,
          subtitle: l10n.paneerTikkaSubtitle,
          statusIcon: Icons.warning_amber_rounded,
          statusColor: Colors.orange,
          tags: [l10n.tagDairy, l10n.tagVegetarian],
          message: l10n.considerReplacing,
          messageColor: const Color(0x33FFCA28),
          tipMessage: l10n.tipOliveOil,
        ),
      ]);
    }
    if (selectedTab == MealTab.all || selectedTab == MealTab.avoid) {
      cards.addAll([
        _buildCard(
          l10n,
          index: 4,
          title: l10n.cheesyPasta,
          subtitle: l10n.cheesyPastaSubtitle,
          statusIcon: Icons.close,
          statusColor: Colors.red,
          tags: [l10n.tagGluten, l10n.tagDairy],
          message: l10n.notAMatch,
          messageColor: const Color(0x33FF4C00),
          tipMessage: l10n.tipOliveOil,
        ),
        _buildCard(
          l10n,
          index: 5,
          title: l10n.deepFriedSnacks,
          subtitle: l10n.deepFriedSnacksSubtitle,
          statusIcon: Icons.close,
          statusColor: Colors.red,
          tags: [l10n.tagDeepFried, l10n.tagHighOil],
          message: l10n.avoidThisMeal,
          messageColor: const Color(0x33FF4C00),
          tipMessage: l10n.tipOliveOil,
        ),
      ]);
    }

    return Column(children: cards);
  }

  /// -------------------- CARD WIDGET --------------------
  Widget _buildCard(
      AppLocalizations l10n, {
        required int index,
        required String title,
        required String subtitle,
        required IconData statusIcon,
        required Color statusColor,
        required List<String> tags,
        required String message,
        required Color messageColor,
        required String tipMessage,
      }) {
    final bool isTipsVisible = tipsVisibility[index] ?? false;

    return Container(
      width: 352,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey)),
                ],
              ),
              Icon(statusIcon, color: statusColor, size: 24),
            ],
          ),
          const SizedBox(height: 8),

          /// TAGS
          Wrap(
            spacing: 8,
            children: tags.map((tag) => _buildTag(tag)).toList(),
          ),
          const SizedBox(height: 8),

          /// MESSAGE BOX
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: messageColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(message,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
          ),

          const SizedBox(height: 12),

          /// ✅ Tips Section
          GestureDetector(
            onTap: () {
              setState(() {
                tipsVisibility[index] = !isTipsVisible;
              });
            },
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
          if (isTipsVisible) ...[
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
                tipMessage,
                style:
                GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    Color bg;
    Color textColor = Colors.black;

    if (text.contains("Gluten-Free") ||
        text.contains("Sin Gluten") ||
        text.contains("Sans Gluten") ||
        text.contains("Vegan") ||
        text.contains("Vegano") ||
        text.contains("Végétalien")) {
      bg = const Color(0xFFDCFCE7);
    } else if (text.contains("Dairy") ||
        text.contains("Lácteos") ||
        text.contains("Laitiers")) {
      bg = const Color(0xFFDBEAFE);
      textColor = const Color(0xFF1D4ED8);
    } else if (text.contains("Spicy") ||
        text.contains("Picante") ||
        text.contains("Épicé")) {
      bg = const Color(0xFFFFE4E0);
      textColor = const Color(0xFFC2410C);
    } else if (text.contains("Protein") ||
        text.contains("Proteínas") ||
        text.contains("Protéines")) {
      bg = const Color(0xFFE0F2FE);
      textColor = Colors.blue.shade900;
    } else {
      bg = const Color(0xFFF3F4F6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(text,
          style: GoogleFonts.poppins(fontSize: 12, color: textColor)),
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
            onPressed: () => context.go(RoutePath.askChatBot.addBasePath),
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