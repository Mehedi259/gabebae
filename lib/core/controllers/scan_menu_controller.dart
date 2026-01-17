// lib/core/controllers/scan_menu_controller.dart
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../global/model/scan_menu_model.dart';
import '../services/scan_menu_service.dart';

class ScanMenuController extends GetxController {
  // Loading state
  final RxBool isScanning = false.obs;
  final RxBool hasScanResult = false.obs;

  // ✅ Store XFile for images and PlatformFile for PDFs
  final RxList<XFile> scannedImages = <XFile>[].obs;
  final RxList<PlatformFile> scannedPdfs = <PlatformFile>[].obs;

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

  /// Add PDF to scan list
  void addPdf(PlatformFile pdf) {
    scannedPdfs.add(pdf);
    developer.log('✅ PDF added. Total: ${scannedPdfs.length}',
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

  /// Remove PDF from scan list
  void removePdf(int index) {
    if (index >= 0 && index < scannedPdfs.length) {
      scannedPdfs.removeAt(index);
      developer.log('🗑️ PDF removed. Remaining: ${scannedPdfs.length}',
          name: 'ScanMenuController');
    }
  }

  /// Clear all images
  void clearImages() {
    scannedImages.clear();
    developer.log('🗑️ All images cleared', name: 'ScanMenuController');
  }

  /// Clear all PDFs
  void clearPdfs() {
    scannedPdfs.clear();
    developer.log('🗑️ All PDFs cleared', name: 'ScanMenuController');
  }

  /// Run OCR scan with images and PDFs
  Future<bool> runScan() async {
    if (scannedImages.isEmpty && scannedPdfs.isEmpty) {
      developer.log('⚠️ No files to scan', name: 'ScanMenuController');
      return false;
    }

    try {
      isScanning.value = true;
      developer.log(
          '🔄 Starting OCR scan with ${scannedImages.length} images and ${scannedPdfs.length} PDFs...',
          name: 'ScanMenuController');

      final result = await ScanMenuService.scanMenu(
        images: scannedImages.toList(),
        pdfs: scannedPdfs.toList(),
      );

      if (result != null) {
        scanResult.value = result;
        hasScanResult.value = true;

        developer.log('✅ Scan completed successfully',
            name: 'ScanMenuController');
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
    scannedPdfs.clear();
    scanResult.value = null;
    hasScanResult.value = false;
    selectedFilter.value = 'all';
    tipsVisibility.clear();
    developer.log('🔄 Scan data reset', name: 'ScanMenuController');
  }

  @override
  void onClose() {
    clearImages();
    clearPdfs();
    super.onClose();
  }
}