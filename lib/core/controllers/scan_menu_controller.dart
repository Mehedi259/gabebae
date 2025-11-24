// lib/core/controllers/scan_menu_controller.dart
import 'dart:io';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // ✅ Add this
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ Add this
import '../../global/model/scan_menu_model.dart';
import '../services/scan_menu_service.dart';

class ScanMenuController extends GetxController {
  // Loading state
  final RxBool isScanning = false.obs;
  final RxBool hasScanResult = false.obs;

  // ✅ Store XFile instead of File for web compatibility
  final RxList<XFile> scannedImages = <XFile>[].obs;

  // OCR Result
  final Rx<OcrScanResponse?> scanResult = Rx<OcrScanResponse?>(null);

  // Filter state for results screen
  final RxString selectedFilter = 'all'.obs;

  // Tips visibility tracking
  final RxMap<int, bool> tipsVisibility = <int, bool>{}.obs;

  /// Add image to scan list
  void addImage(XFile image) {
    scannedImages.add(image);
    developer.log('✅ Image added. Total: ${scannedImages.length}',
        name: 'ScanMenuController');
  }

  /// Remove image from scan list
  void removeImage(int index) {
    if (index >= 0 && index < scannedImages.length) {
      scannedImages.removeAt(index);
      developer.log('🗑️ Image removed. Remaining: ${scannedImages.length}',
          name: 'ScanMenuController');
    }
  }

  /// Clear all images
  void clearImages() {
    scannedImages.clear();
    developer.log('🗑️ All images cleared', name: 'ScanMenuController');
  }

  /// Run OCR scan
  Future<bool> runScan() async {
    if (scannedImages.isEmpty) {
      developer.log('⚠️ No images to scan', name: 'ScanMenuController');
      return false;
    }

    try {
      isScanning.value = true;
      developer.log('🔄 Starting OCR scan with ${scannedImages.length} images...',
          name: 'ScanMenuController');

      final result = await ScanMenuService.scanMenu(scannedImages.toList());

      if (result != null) {
        scanResult.value = result;
        hasScanResult.value = true;

        developer.log('✅ Scan completed successfully', name: 'ScanMenuController');
        developer.log('📊 Total items: ${result.foodItems.length}',
            name: 'ScanMenuController');
        developer.log('✅ Safe items: ${result.foodItems.safeCount}',
            name: 'ScanMenuController');
        developer.log('⚠️ Modify items: ${result.foodItems.modifyCount}',
            name: 'ScanMenuController');
        developer.log('❌ Avoid items: ${result.foodItems.avoidCount}',
            name: 'ScanMenuController');

        return true;
      } else {
        developer.log('❌ Scan failed', name: 'ScanMenuController');
        return false;
      }
    } catch (e) {
      developer.log('❌ Error during scan: $e', name: 'ScanMenuController');
      return false;
    } finally {
      isScanning.value = false;
    }
  }

  /// Get filtered food items based on selected filter
  List<FoodItem> get filteredFoodItems {
    if (scanResult.value == null) return [];

    final allItems = scanResult.value!.foodItems;

    switch (selectedFilter.value) {
      case 'safe':
        return allItems.safeItems;
      case 'modify':
        return allItems.modifyItems;
      case 'avoid':
        return allItems.avoidItems;
      case 'all':
      default:
        return allItems;
    }
  }

  /// Change filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    developer.log('🔍 Filter changed to: $filter', name: 'ScanMenuController');
  }

  /// Toggle tips visibility for a card
  void toggleTips(int index) {
    tipsVisibility[index] = !(tipsVisibility[index] ?? false);
  }

  /// Get tips visibility state
  bool getTipsVisibility(int index) {
    return tipsVisibility[index] ?? false;
  }

  /// Get statistics
  Map<String, int> get statistics {
    if (scanResult.value == null) {
      return {'total': 0, 'safe': 0, 'modify': 0, 'avoid': 0};
    }

    final items = scanResult.value!.foodItems;
    return {
      'total': items.length,
      'safe': items.safeCount,
      'modify': items.modifyCount,
      'avoid': items.avoidCount,
    };
  }

  /// Reset scan data
  void resetScan() {
    scannedImages.clear();
    scanResult.value = null;
    hasScanResult.value = false;
    selectedFilter.value = 'all';
    tipsVisibility.clear();
    developer.log('🔄 Scan data reset', name: 'ScanMenuController');
  }

  @override
  void onClose() {
    clearImages();
    super.onClose();
  }
}