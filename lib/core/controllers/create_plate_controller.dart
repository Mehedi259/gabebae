// lib/core/controllers/create_plate_controller.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../global/model/create_plate_model.dart';
import '../../core/services/create_plate_service.dart';

class CreatePlateController extends GetxController {
  // Observable States
  var selectedIngredients = <String>[].obs;
  var isLoadingCombo = false.obs;
  var isSavingMeal = false.obs;
  var comboSuggestions = <String>[].obs;
  var errorMessage = ''.obs;

  // Current Meal Data
  var currentMealName = ''.obs;
  File? currentMealImage;
  Uint8List? currentMealImageBytes; // For Web

  /// Add Ingredient to Selection
  void addIngredient(String ingredient) {
    if (!selectedIngredients.contains(ingredient)) {
      selectedIngredients.add(ingredient);
      developer.log('✅ Added ingredient: $ingredient',
          name: 'CreatePlateController');
    }
  }

  /// Remove Ingredient from Selection
  void removeIngredient(String ingredient) {
    selectedIngredients.remove(ingredient);
    developer.log('❌ Removed ingredient: $ingredient',
        name: 'CreatePlateController');
  }

  /// Toggle Ingredient Selection
  void toggleIngredient(String ingredient) {
    if (selectedIngredients.contains(ingredient)) {
      removeIngredient(ingredient);
    } else {
      addIngredient(ingredient);
    }
  }

  /// Clear All Selected Ingredients
  void clearIngredients() {
    selectedIngredients.clear();
    developer.log('🧹 Cleared all ingredients', name: 'CreatePlateController');
  }

  /// Fetch Combo Suggestions from API
  Future<void> fetchComboSuggestions({
    required int profileId,
    required String profileName,
  }) async {
    try {
      isLoadingCombo.value = true;
      errorMessage.value = '';

      developer.log('🔄 Fetching combo suggestions...', name: 'CreatePlateController');

      final response = await CreatePlateService.getComboSuggestions(
        profileId: profileId,
        profileName: profileName,
      );

      // Extract ingredient names and update selection
      comboSuggestions.value =
          response.combo.map((item) => item.name).toList();

      selectedIngredients.value = comboSuggestions;

      developer.log('✅ Combo suggestions loaded: ${comboSuggestions.length}',
          name: 'CreatePlateController');

      Get.snackbar(
        'Success',
        'Combo suggestions loaded!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      developer.log('❌ Error fetching combo: $e',
          name: 'CreatePlateController');

      Get.snackbar(
        'Error',
        'Failed to load combo suggestions',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingCombo.value = false;
    }
  }

  /// Set Meal Name
  void setMealName(String name) {
    currentMealName.value = name;
  }

  /// Set Meal Image (Mobile)
  void setMealImage(File? image) {
    currentMealImage = image;
    developer.log('📷 Meal image set', name: 'CreatePlateController');
  }

  /// Set Meal Image Bytes (Web)
  void setMealImageBytes(Uint8List? bytes) {
    currentMealImageBytes = bytes;
    developer.log('📷 Meal image bytes set (Web)', name: 'CreatePlateController');
  }

  /// Save My Plate
  Future<bool> saveMyPlate({
    required String mealName,
    required List<String> plateCombo,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      isSavingMeal.value = true;
      errorMessage.value = '';

      developer.log('💾 Saving meal: $mealName', name: 'CreatePlateController');

      final request = MyPlateRequest(
        mealName: mealName,
        plateCombo: plateCombo,
        imagePath: imageFile?.path,
        imageBytes: imageBytes,
      );

      final response = await CreatePlateService.saveMyPlate(request: request);

      developer.log('✅ Meal saved successfully: ${response.mealName}',
          name: 'CreatePlateController');

      Get.snackbar(
        'Success',
        'Meal "$mealName" saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Clear current data after successful save
      clearMealData();

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      developer.log('❌ Error saving meal: $e', name: 'CreatePlateController');

      Get.snackbar(
        'Error',
        'Failed to save meal',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isSavingMeal.value = false;
    }
  }

  /// Clear Meal Data
  void clearMealData() {
    currentMealName.value = '';
    currentMealImage = null;
    currentMealImageBytes = null;
    selectedIngredients.clear();
    developer.log('🧹 Cleared meal data', name: 'CreatePlateController');
  }

  /// Check if meal can be saved
  bool get canSaveMeal {
    return currentMealName.value.trim().isNotEmpty &&
        selectedIngredients.isNotEmpty;
  }

  @override
  void onClose() {
    clearMealData();
    super.onClose();
  }
}