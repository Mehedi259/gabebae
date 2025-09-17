import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildMyPlateScreen extends StatefulWidget {
  const BuildMyPlateScreen({super.key});

  @override
  State<BuildMyPlateScreen> createState() => _BuildMyPlateScreenState();
}

class _BuildMyPlateScreenState extends State<BuildMyPlateScreen> {
  final List<String> selectedIngredients = [];
  final List<Map<String, dynamic>> safeIngredients = [
    {"name": "🍅 Extra Sauce", "color": const Color(0xFFDCFCE7)},
    {"name": "🥬 Extra Veggies", "color": const Color(0xFFDCFCE7)},
    {"name": "🫒 Olives", "color": const Color(0xFFDCFCE7)},
    {"name": "🌶️ Spicy", "color": const Color(0x33FFCC44)},
    {"name": "🧄 Garlic", "color": const Color(0x33FECACA)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),

      /// HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 1,
          titleSpacing: 16,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 15),
              Text(
                "🍽️ Your Meal Results",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// TITLE SECTION
              Text(
                "🍽️ Build My Plate",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Pick safe ingredients 🌿 or try a \n suggested combo 💛",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 32),

              /// MY PLATE SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF669A59), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Plate",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(0xFF154452),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (selectedIngredients.isEmpty)
                      Text(
                        "✨ Add ingredients to build your plate",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF9CA3AF),
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedIngredients.map((ingredient) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF10B981)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ingredient,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIngredients.remove(ingredient);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Suggest combo logic
                        setState(() {
                          selectedIngredients.clear();
                          selectedIngredients.addAll([
                            "🥬 Extra Veggies",
                            "🧄 Garlic",
                            "🫒 Olives"
                          ]);
                        });
                      },
                      icon: const Icon(Icons.auto_awesome, color: Colors.yellow),
                      label: Text(
                        "Suggest Combo",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE27B4F),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to next screen or save
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Plate looks good! 👍")),
                        );
                      },
                      icon: const Icon(Icons.thumb_up, color: Colors.yellow),
                      label: Text(
                        "Looks Good",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// SAFE INGREDIENTS SECTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Safe for You",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// INGREDIENT CHIPS
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: safeIngredients.map((ingredient) {
                  final isSelected = selectedIngredients.contains(ingredient["name"]);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIngredients.remove(ingredient["name"]);
                        } else {
                          selectedIngredients.add(ingredient["name"]);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF10B981) : ingredient["color"],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        ingredient["name"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              /// INFO TEXT
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF5F5F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "✨ These are the items Menu Sidekick spotted as safe for you. Some restaurants may not allow mixing & matching, so double-check with your server about what's available.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                          height: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Space for bottom buttons
            ],
          ),
        ),
      ),

      /// BOTTOM BUTTONS
      bottomNavigationBar: Container(
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
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

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
                  color: const Color(0xFFE27B4F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}