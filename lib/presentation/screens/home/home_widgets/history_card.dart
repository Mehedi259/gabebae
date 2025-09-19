import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final int safeItems;
  final int notSafeItems;
  final String imagePath;

  const HistoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.safeItems,
    required this.notSafeItems,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(title,
                    style: const TextStyle(
                        fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (safeItems > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x1A6CA865),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text("✅ $safeItems Safe Items",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6CA865))),
                      ),
                    if (notSafeItems > 0) const SizedBox(width: 8),
                    if (notSafeItems > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF991B1B),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text("⚠️ $notSafeItems Not Safe",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
