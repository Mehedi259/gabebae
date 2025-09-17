import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ---------- FIXED HEADER ----------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(),
      ),

      /// ---------- SCROLLABLE BODY ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildFilterTabs(),
            const SizedBox(height: 8),
            _buildALaCarteButton(),
            const SizedBox(height: 12),
            _buildCardsView(),
          ],
        ),
      ),

      /// ---------- FIXED BOTTOM BUTTONS ----------
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  /// -------------------- HEADER --------------------
  Widget _buildHeader() {
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
            onPressed: () {},
          ),
          Text(
            "🍽️ Your Meal Results",
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
                Text("Quick",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 12)),
                Text("Pdf View",
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
  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _tabButton("📋 All", MealTab.all, Colors.blueGrey),
            const SizedBox(width: 8),
            _tabButton("✅ Safe", MealTab.safe, Colors.green),
            const SizedBox(width: 8),
            _tabButton("⚠️ Modify", MealTab.modify, Colors.orange),
            const SizedBox(width: 8),
            _tabButton("❌ Avoid", MealTab.avoid, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, MealTab tab, Color color) {
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
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isActive ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------- A La Carte Button --------------------
  Widget _buildALaCarteButton() {
    return Container(
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
          "✨ À La Carte Mode",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// -------------------- CARD SECTION --------------------
  Widget _buildCardsView() {
    List<Widget> cards = [];

    if (selectedTab == MealTab.all || selectedTab == MealTab.safe) {
      cards.addAll([
        _buildCard(
          index: 0,
          title: "Grilled Chicken Salad",
          subtitle: "Salade de Poulet Grillé",
          statusIcon: Icons.check_circle,
          statusColor: Colors.green,
          tags: ["🌱 Gluten-Free", "🥛 Dairy-Free"],
          message: "Aligned and glowing — this meal’s an exact match! 🌿",
          messageColor: const Color(0xFFF0FDF4),
        ),
        _buildCard(
          index: 2,
          title: "Quinoa Buddha Bowl",
          subtitle: "Bol de Bouddha au Quinoa",
          statusIcon: Icons.check_circle,
          statusColor: Colors.green,
          tags: ["🌱 Vegan", "💪 High-Protein"],
          message: "Perfect power bowl — great for muscle recovery 💪",
          messageColor: const Color(0xFFF0FDF4),
        ),
      ]);
    }
    if (selectedTab == MealTab.all || selectedTab == MealTab.modify) {
      cards.addAll([
        _buildCard(
          index: 1,
          title: "Vegetable Stir Fry",
          subtitle: "Légumes Sautés",
          statusIcon: Icons.warning_amber_rounded,
          statusColor: Colors.orange,
          tags: ["🌱 Vegan", "🌶️ Spicy"],
          message: "⚠️ Almost safe, just tweak it a little ✨\n💡 Skip spicy → Safe 🌿",
          messageColor: const Color(0x33FFCA28),
        ),
        _buildCard(
          index: 3,
          title: "Paneer Tikka",
          subtitle: "Tikka de Paneer",
          statusIcon: Icons.warning_amber_rounded,
          statusColor: Colors.orange,
          tags: ["🥛 Dairy", "🌱 Vegetarian"],
          message: "⚠️ Consider replacing paneer with tofu for a lighter option.",
          messageColor: const Color(0x33FFCA28),
        ),
      ]);
    }
    if (selectedTab == MealTab.all || selectedTab == MealTab.avoid) {
      cards.addAll([
        _buildCard(
          index: 4,
          title: "Cheesy Pasta",
          subtitle: "Pâtes au Fromage",
          statusIcon: Icons.close,
          statusColor: Colors.red,
          tags: ["🌾 Gluten", "🥛 Dairy"],
          message: "Not a match for you, lovely 💛",
          messageColor: const Color(0x33FF4C00),
        ),
        _buildCard(
          index: 5,
          title: "Deep Fried Snacks",
          subtitle: "Snacks Frits",
          statusIcon: Icons.close,
          statusColor: Colors.red,
          tags: ["🍟 Deep-Fried", "🍳 High-Oil"],
          message: "❌ Avoid this meal for a lighter, healthier day.",
          messageColor: const Color(0x33FF4C00),
        ),
      ]);
    }

    return Column(children: cards);
  }

  /// -------------------- CARD WIDGET --------------------
  Widget _buildCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData statusIcon,
    required Color statusColor,
    required List<String> tags,
    required String message,
    required Color messageColor,
  }) {
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
          /// HEADER + FAVORITE
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
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() {
                      if (favoriteCards.contains(index)) {
                        favoriteCards.remove(index);
                      } else {
                        favoriteCards.add(index);
                      }
                    }),
                    child: Icon(
                      favoriteCards.contains(index)
                          ? Icons.star
                          : Icons.star_border,
                      color: favoriteCards.contains(index)
                          ? Colors.amber
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
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
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    Color bg;
    Color textColor = Colors.black;

    if (text.contains("Gluten-Free") || text.contains("Vegan")) {
      bg = const Color(0xFFDCFCE7);
    } else if (text.contains("Dairy")) {
      bg = const Color(0xFFDBEAFE);
      textColor = const Color(0xFF1D4ED8);
    } else if (text.contains("Spicy")) {
      bg = const Color(0xFFFFE4E0);
      textColor = const Color(0xFFC2410C);
    } else if (text.contains("High-Protein")) {
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
  Widget _buildBottomButtons() {
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
            onPressed: () {},
            icon: const Icon(Icons.chat, color: Colors.white),
            label: Text(
              "Ask AI Chat About This",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
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
            onPressed: () {},
            label: Text(
              "Share Your Diet via QR Code",
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
