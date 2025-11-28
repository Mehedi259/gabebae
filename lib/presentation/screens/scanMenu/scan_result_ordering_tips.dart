// lib/presentation/screens/scanMenu/scan_result_ordering_tips.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/controllers/create_plate_controller.dart'; // Add this
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';

class OrderingTipsScreen extends StatefulWidget {
  const OrderingTipsScreen({super.key});

  @override
  State<OrderingTipsScreen> createState() => _OrderingTipsScreenState();
}

class _OrderingTipsScreenState extends State<OrderingTipsScreen> {
  late CreatePlateController _controller;

  @override
  void initState() {
    super.initState();
    // Get the existing controller instance
    _controller = Get.find<CreatePlateController>();
  }

  List<Map<String, dynamic>> getTips(AppLocalizations l10n) {
    return [
      {
        "icon": "🌿",
        "title": l10n.tipAskAboutOilsTitle,
        "description": l10n.tipAskAboutOilsDesc,
      },
      {
        "icon": "✨",
        "title": l10n.tipSimplifySaucesTitle,
        "description": l10n.tipSimplifySaucesDesc,
      },
      {
        "icon": "💧",
        "title": l10n.tipStayHydratedTitle,
        "description": l10n.tipStayHydratedDesc,
      },
      {
        "icon": "❓",
        "title": l10n.tipAskYourServerTitle,
        "description": l10n.tipAskYourServerDesc,
      },
    ];
  }

  // Helper method to determine color based on ingredient name
  Map<String, Color> _getIngredientColors(String ingredient, AppLocalizations l10n) {
    // Check if it's spicy (you can customize this logic)
    if (ingredient.toLowerCase().contains('spicy') ||
        ingredient.toLowerCase().contains('🌶️') ||
        ingredient == l10n.spicy) {
      return {
        'bg': const Color(0xFFFEF3C7),
        'text': const Color(0xFFD97706),
        'border': const Color(0xFFD97706),
      };
    }
    // Check if it's garlic
    else if (ingredient.toLowerCase().contains('garlic') ||
        ingredient == l10n.garlic) {
      return {
        'bg': const Color(0x33FECACA),
        'text': const Color(0xFFDC2626),
        'border': const Color(0xFFDC2626),
      };
    }
    // Default green color for safe ingredients
    return {
      'bg': const Color(0xFFDCFCE7),
      'text': const Color(0xFF059669),
      'border': const Color(0xFF10B981),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tips = getTips(l10n);

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
                        l10n.orderingTipsTitle,
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
                        l10n.orderingTipsSubtitle,
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

                /// PLATE COMBO SECTION (Updated with Obx)
                Obx(() => Container(
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
                        l10n.yourPlateCombo,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF1F2937),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show message if no ingredients selected
                      if (_controller.selectedIngredients.isEmpty)
                        Text(
                          l10n.addIngredientsPrompt,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _controller.selectedIngredients.map((ingredient) {
                            final colors = _getIngredientColors(ingredient, l10n);

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: colors['bg'],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: colors['border']!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ingredient,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colors['text'],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => _controller.removeIngredient(ingredient),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: colors['text'],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                )),

                const SizedBox(height: 32),

                /// TIPS SELECTION TITLE
                Text(
                  l10n.tipsSelection,
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

      /// BOTTOM BUTTONS (unchanged)
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(RoutePath.scanResultSaveYourMeals.addBasePath),
                    icon: const Icon(Icons.bookmark, color: Colors.white),
                    label: Text(
                      l10n.saveMeal,
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
                      l10n.qrShare,
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