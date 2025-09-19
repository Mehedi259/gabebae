import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class OrderingTipsScreen extends StatefulWidget {
  const OrderingTipsScreen({super.key});

  @override
  State<OrderingTipsScreen> createState() => _OrderingTipsScreenState();
}

class _OrderingTipsScreenState extends State<OrderingTipsScreen> {
  final List<String> plateCombo = [
    "🥬 Extra Veggies",
    "🌶️ Spicy",
    "🌶️ Spicy",
  ];

  final List<Map<String, dynamic>> tips = [
    {
      "icon": "🌿",
      "title": "Ask About Oils",
      "description": "Confirm chicken is grilled in olive oil, not butter.",
    },
    {
      "icon": "✨",
      "title": "Simplify Sauces",
      "description": "Request sauces on the side so you stay in control.",
    },
    {
      "icon": "💧",
      "title": "Stay Hydrated",
      "description": "Request sauces on the side so you stay in control.",
    },
    {
      "icon": "❓",
      "title": "Ask Your Server",
      "description": "Could you confirm if the rice is cooked in butter or oil?\n\nAny soy sauce in this marinade?",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                /// TITLE SECTION
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: Color(0xFF10B981), size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Ordering Tips for Your Plate",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Quick reminders to keep your meal safe & glowing✨",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                /// PLATE COMBO SECTION
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF10B981), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "YOUR PLATE COMBO",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF1F2937),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: plateCombo.map((ingredient) {
                          Color bgColor = const Color(0xFFDCFCE7);
                          Color textColor = const Color(0xFF059669);

                          if (ingredient.contains("Spicy")) {
                            bgColor = const Color(0xFFFEF3C7);
                            textColor = const Color(0xFFD97706);
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: textColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ingredient,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.close,
                                  size: 16,
                                  color: textColor,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                /// TIPS SELECTION TITLE
                Text(
                  "Tips Selection",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 20),

                /// TIPS LIST
                ...tips.map((tip) => _buildTipCard(
                  icon: tip["icon"],
                  title: tip["title"],
                  description: tip["description"],
                )),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      /// BOTTOM BUTTONS
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TOP ROW BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(RoutePath.scanResultSaveYourMeals.addBasePath),
                    icon: const Icon(Icons.bookmark, color: Colors.white),
                    label: Text(
                      "Save Meal",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
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
                    onPressed: () => context.go(RoutePath.myQrCode.addBasePath),
                    icon: const Icon(Icons.qr_code, color: Colors.white),
                    label: Text(
                      "QR Share",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
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
            const SizedBox(height: 12),

            /// AI CHAT BUTTON
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
                "Ask AI Chat About This",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIP HEADER
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// TIP DESCRIPTION
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
