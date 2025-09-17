import 'package:flutter/material.dart';
import 'package:MenuSideKick/core/custom_assets/assets.gen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),

      /// ===== Bottom Navigation Bar =====
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF669A59),
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Sidekick AI",
          ),
        ],
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFE8F4F5),
                    child: Image.asset(
                      Assets.images.avt2.path,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Hi, John",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text("✨ 1"),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.person, color: Color(0xFFEA580C)),
                ],
              ),

              const SizedBox(height: 24),

              /// ===== Dining Profile Card =====
              Container(
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
                    /// Title Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "✨ Your Dining Profile ✨",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Diet
                    const Text("Diet",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildChip("Vegan", Colors.green.shade100, Colors.green),
                        _buildChip("Dairy-Free", Colors.blue.shade100, Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Allergies
                    const Text("Allergies",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildChip("Peanuts", Colors.red.shade100, Colors.red),
                        _buildChip("Shellfish", Colors.red.shade100, Colors.red),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Health
                    const Text("Health",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 8),
                    _buildChip("Diabetic", Colors.yellow.shade100, Colors.orange),

                    const SizedBox(height: 16),

                    /// QR Code link
                    const Text(
                      "Share Your Diet via QR Code",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEA580C),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ===== Favorites Section =====
              _buildSectionHeader("Your Favorites"),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFoodCard("Avocado Toast", Assets.images.avocadoToast.path),
                    _buildFoodCard("Quinoa Bowl", Assets.images.quinoaBowl.path),
                    _buildFoodCard("Green Smoothie", Assets.images.greenSmoothie.path),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ===== Recent Scans Section =====
              _buildSectionHeader("Recent Scans"),
              const SizedBox(height: 16),
              _buildScanCard(
                title: "Bella Vistal Italian",
                date: "Scanned On Aug 25, 10:32 AM",
                safeItems: 3,
                notSafeItems: 2,
                imagePath: Assets.images.bellaVistalItalian.path,
              ),
              _buildScanCard(
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

  /// ===== Reusable Chip =====
  static Widget _buildChip(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  /// ===== Reusable Section Header =====
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const Text(
          "See All",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEA580C),
          ),
        ),
      ],
    );
  }

  /// ===== Reusable Food Card =====
  Widget _buildFoodCard(String title, String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
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
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(imagePath, height: 100, width: 140, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ===== Reusable Scan Card =====
  Widget _buildScanCard({
    required String title,
    required String date,
    required int safeItems,
    required int notSafeItems,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (safeItems > 0)
                      Text(
                        "✅ $safeItems Safe Items  ",
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    if (notSafeItems > 0)
                      Text(
                        "⚠️ $notSafeItems Not Safe",
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
