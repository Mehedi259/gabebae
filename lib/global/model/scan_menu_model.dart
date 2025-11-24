// lib/global/model/scan_menu_model.dart

import 'dart:ui';

import 'package:flutter/material.dart';

/// Main OCR Response Model
class OcrScanResponse {
  final List<FoodItem> foodItems;

  OcrScanResponse({required this.foodItems});

  factory OcrScanResponse.fromJson(Map<String, dynamic> json) {
    return OcrScanResponse(
      foodItems: (json['food_items'] as List?)
          ?.map((item) => FoodItem.fromJson(item))
          .toList() ??
          [],
    );
  }
}

/// Food Item Model
class FoodItem {
  final String foodTitle;
  final String frenchName;
  final List<IngredientMark> ingredientsMarks;
  final String aiRecommendations;
  final String tips;
  final String foodMark; // "safe", "unsafe", "caution"

  FoodItem({
    required this.foodTitle,
    required this.frenchName,
    required this.ingredientsMarks,
    required this.aiRecommendations,
    required this.tips,
    required this.foodMark,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodTitle: json['food_title'] ?? '',
      frenchName: json['french_name'] ?? '',
      ingredientsMarks: (json['ingredients_marks'] as List?)
          ?.map((item) => IngredientMark.fromJson(item))
          .toList() ??
          [],
      aiRecommendations: json['ai_recommendations'] ?? '',
      tips: json['tips'] ?? '',
      foodMark: json['food_mark'] ?? 'caution',
    );
  }

  /// Check if food is safe
  bool get isSafe => foodMark.toLowerCase() == 'safe';

  /// Check if food needs modification
  bool get needsModification => foodMark.toLowerCase() == 'caution';

  /// Check if food should be avoided
  bool get shouldAvoid => foodMark.toLowerCase() == 'unsafe';

  /// Get status color
  Color get statusColor {
    switch (foodMark.toLowerCase()) {
      case 'safe':
        return const Color(0xFF10B981);
      case 'caution':
        return const Color(0xFFF59E0B);
      case 'unsafe':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// Get status icon
  IconData get statusIcon {
    switch (foodMark.toLowerCase()) {
      case 'safe':
        return Icons.check_circle;
      case 'caution':
        return Icons.warning_amber_rounded;
      case 'unsafe':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  /// Get background color for message box
  Color get messageBackgroundColor {
    switch (foodMark.toLowerCase()) {
      case 'safe':
        return const Color(0xFFF0FDF4);
      case 'caution':
        return const Color(0x33FFCA28);
      case 'unsafe':
        return const Color(0x33FF4C00);
      default:
        return const Color(0xFFF3F4F6);
    }
  }
}

/// Ingredient Mark Model
class IngredientMark {
  final String ingredient;
  final String mark; // "safe", "unsafe", "caution"

  IngredientMark({
    required this.ingredient,
    required this.mark,
  });

  factory IngredientMark.fromJson(Map<String, dynamic> json) {
    return IngredientMark(
      ingredient: json['ingredient'] ?? '',
      mark: json['mark'] ?? 'caution',
    );
  }

  /// Check if ingredient is safe
  bool get isSafe => mark.toLowerCase() == 'safe';

  /// Check if ingredient is unsafe
  bool get isUnsafe => mark.toLowerCase() == 'unsafe';

  /// Check if ingredient needs caution
  bool get needsCaution => mark.toLowerCase() == 'caution';

  /// Get tag color based on mark
  Color get tagColor {
    switch (mark.toLowerCase()) {
      case 'safe':
        return const Color(0xFFDCFCE7);
      case 'caution':
        return const Color(0xFFFFE4E0);
      case 'unsafe':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  /// Get text color based on mark
  Color get textColor {
    switch (mark.toLowerCase()) {
      case 'safe':
        return const Color(0xFF059669);
      case 'caution':
        return const Color(0xFFC2410C);
      case 'unsafe':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

/// Extension for easy filtering
extension FoodItemListExtension on List<FoodItem> {
  /// Get all safe items
  List<FoodItem> get safeItems =>
      where((item) => item.isSafe).toList();

  /// Get all items that need modification
  List<FoodItem> get modifyItems =>
      where((item) => item.needsModification).toList();

  /// Get all items to avoid
  List<FoodItem> get avoidItems =>
      where((item) => item.shouldAvoid).toList();

  /// Get count of safe items
  int get safeCount => safeItems.length;

  /// Get count of items needing modification
  int get modifyCount => modifyItems.length;

  /// Get count of items to avoid
  int get avoidCount => avoidItems.length;
}