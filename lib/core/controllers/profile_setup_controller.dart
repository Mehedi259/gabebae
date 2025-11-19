// lib/core/controllers/profile_setup_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../global/model/profile_setup_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../services/profile_setup_services.dart';

class ProfileSetupController extends GetxController {
  // Loading states
  final RxBool isLoadingEatingStyles = false.obs;
  final RxBool isLoadingAllergies = false.obs;
  final RxBool isLoadingMedicalConditions = false.obs;
  final RxBool isLoadingAvatars = false.obs;
  final RxBool isGeneratingMagicList = false.obs;
  final RxBool isCreatingProfile = false.obs;

  // Data lists
  final RxList<EatingStyle> eatingStyles = <EatingStyle>[].obs;
  final RxList<Allergy> allergies = <Allergy>[].obs;
  final RxList<MedicalCondition> medicalConditions = <MedicalCondition>[].obs;
  final RxList<Avatar> avatars = <Avatar>[].obs;
  final RxList<String> magicList = <String>[].obs;

  // Selected items
  final RxMap<String, String> selectedEatingStyles = <String, String>{}.obs;
  final RxSet<String> selectedAllergies = <String>{}.obs;
  final RxSet<String> selectedMedicalConditions = <String>{}.obs;
  final RxSet<String> selectedMagicListItems = <String>{}.obs;
  final Rx<String?> selectedAvatar = Rx<String?>(null);

  // Profile details
  final TextEditingController nameController = TextEditingController();
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final RxString country = 'USA'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEatingStyles();
    fetchAllergies();
    fetchMedicalConditions();
    fetchAvatars();
  }

  /// Fetch Eating Styles
  Future<void> fetchEatingStyles() async {
    try {
      isLoadingEatingStyles.value = true;
      final result = await ProfileSetupService.getEatingStyles();
      eatingStyles.value = result;
    } catch (e) {
      developer.log('❌ Error fetching eating styles: $e', name: 'ProfileSetupController');
      _showError('Failed to load eating styles');
    } finally {
      isLoadingEatingStyles.value = false;
    }
  }

  /// Fetch Allergies
  Future<void> fetchAllergies() async {
    try {
      isLoadingAllergies.value = true;
      final result = await ProfileSetupService.getAllergies();
      allergies.value = result;
    } catch (e) {
      developer.log('❌ Error fetching allergies: $e', name: 'ProfileSetupController');
      _showError('Failed to load allergies');
    } finally {
      isLoadingAllergies.value = false;
    }
  }

  /// Fetch Medical Conditions
  Future<void> fetchMedicalConditions() async {
    try {
      isLoadingMedicalConditions.value = true;
      final result = await ProfileSetupService.getMedicalConditions();
      medicalConditions.value = result;
    } catch (e) {
      developer.log('❌ Error fetching medical conditions: $e', name: 'ProfileSetupController');
      _showError('Failed to load medical conditions');
    } finally {
      isLoadingMedicalConditions.value = false;
    }
  }

  /// Fetch Avatars
  Future<void> fetchAvatars() async {
    try {
      isLoadingAvatars.value = true;
      final result = await ProfileSetupService.getAvatars();
      avatars.value = result;
    } catch (e) {
      developer.log('❌ Error fetching avatars: $e', name: 'ProfileSetupController');
      _showError('Failed to load avatars');
    } finally {
      isLoadingAvatars.value = false;
    }
  }

  /// Toggle Eating Style - Capitalize level
  void toggleEatingStyle(String name, String level) {
    // Capitalize first letter of level
    final capitalizedLevel = _capitalize(level);

    if (selectedEatingStyles.containsKey(name)) {
      if (selectedEatingStyles[name] == capitalizedLevel) {
        selectedEatingStyles.remove(name);
      } else {
        selectedEatingStyles[name] = capitalizedLevel;
      }
    } else {
      selectedEatingStyles[name] = capitalizedLevel;
    }

    developer.log('✅ Eating style toggled: $name => $capitalizedLevel', name: 'ProfileSetupController');
  }

  /// Helper to capitalize first letter
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Toggle Allergy
  void toggleAllergy(String name) {
    if (selectedAllergies.contains(name)) {
      selectedAllergies.remove(name);
    } else {
      selectedAllergies.add(name);
    }
  }

  /// Toggle Medical Condition
  void toggleMedicalCondition(String name) {
    if (selectedMedicalConditions.contains(name)) {
      selectedMedicalConditions.remove(name);
    } else {
      selectedMedicalConditions.add(name);
    }
  }

  /// Toggle Magic List
  void toggleMagicListItem(String item) {
    if (selectedMagicListItems.contains(item)) {
      selectedMagicListItems.remove(item);
    } else {
      selectedMagicListItems.add(item);
    }
  }

  /// Select Avatar
  void selectAvatar(String avatarUrl) {
    selectedAvatar.value = avatarUrl;
    developer.log('✅ Avatar selected: $avatarUrl', name: 'ProfileSetupController');
  }

  /// Generate Magic List
  Future<bool> generateMagicList() async {
    if (selectedEatingStyles.isEmpty &&
        selectedAllergies.isEmpty &&
        selectedMedicalConditions.isEmpty) {
      _showError('Please select at least one option');
      return false;
    }

    try {
      isGeneratingMagicList.value = true;

      final eatingStyleSelections = selectedEatingStyles.entries
          .map((e) => EatingStyleSelection(name: e.key, level: e.value))
          .toList();

      final result = await ProfileSetupService.generateMagicList(
        eatingStyles: eatingStyleSelections,
        allergies: selectedAllergies.toList(),
        medicalConditions: selectedMedicalConditions.toList(),
      );

      magicList.value = result.magicList;
      selectedMagicListItems.value = result.magicList.toSet();

      // Don't show success snackbar - it causes error
      developer.log('✅ Magic list generated successfully', name: 'ProfileSetupController');
      return true;
    } catch (e) {
      developer.log('❌ Error generating magic list: $e', name: 'ProfileSetupController');
      _showError('Failed to generate magic list');
      return false;
    } finally {
      isGeneratingMagicList.value = false;
    }
  }

  /// Create Profile
  Future<bool> createProfile() async {
    developer.log('🚀 Starting profile creation', name: 'ProfileSetupController');

    // Validation
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return false;
    }

    if (selectedAvatar.value == null || selectedAvatar.value!.isEmpty) {
      _showError('Please select an avatar');
      return false;
    }

    if (selectedEatingStyles.isEmpty) {
      _showError('Please select at least one eating style');
      return false;
    }

    // Set default date if not provided
    if (dateOfBirth.value == null) {
      dateOfBirth.value = DateTime(2000, 1, 1);
      developer.log('⚠️ Using default date of birth', name: 'ProfileSetupController');
    }

    try {
      isCreatingProfile.value = true;

      // Get user ID
      final userId = await StorageHelper.getUserId();
      if (userId == null) {
        developer.log('❌ User ID not found', name: 'ProfileSetupController');
        _showError('User authentication error. Please login again.');
        return false;
      }

      developer.log('✅ User ID: $userId', name: 'ProfileSetupController');

      // Prepare eating style selections with capitalized levels
      final eatingStyleSelections = selectedEatingStyles.entries
          .map((e) => EatingStyleSelection(name: e.key, level: e.value))
          .toList();

      developer.log('📝 Eating styles: ${eatingStyleSelections.map((e) => '${e.name}:${e.level}').toList()}',
          name: 'ProfileSetupController');

      // Create request
      final request = ProfileCreateRequest(
        user: userId,
        eatingStyle: eatingStyleSelections,
        allergies: selectedAllergies.toList(),
        medicalConditions: selectedMedicalConditions.toList(),
        magicList: selectedMagicListItems.toList(),
        profileName: nameController.text.trim(),
        country: country.value,
        avatar: selectedAvatar.value!,
        dateOfBirth: _formatDate(dateOfBirth.value!),
        isActive: true,
      );

      developer.log('📤 Request Data: ${request.toJson()}', name: 'ProfileSetupController');

      // Call API
      final profile = await ProfileSetupService.createProfile(request);

      developer.log('✅ Profile created: ${profile.profileName}', name: 'ProfileSetupController');

      // Show success message
      _showSuccess('Profile created successfully!');

      return true;
    } catch (e) {
      developer.log('❌ Error creating profile: $e', name: 'ProfileSetupController');
      _showError('Failed to create profile. Please try again.');
      return false;
    } finally {
      isCreatingProfile.value = false;
    }
  }

  /// Format date
  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  /// Show Error
  void _showError(String msg) {
    developer.log('❌ Error: $msg', name: 'ProfileSetupController');

    try {
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      developer.log('⚠️ Could not show snackbar: $e', name: 'ProfileSetupController');
    }
  }

  /// Show Success
  void _showSuccess(String msg) {
    developer.log('✅ Success: $msg', name: 'ProfileSetupController');

    try {
      Get.snackbar(
        'Success',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      developer.log('⚠️ Could not show snackbar: $e', name: 'ProfileSetupController');
    }
  }

  /// Reset
  void resetSelections() {
    selectedEatingStyles.clear();
    selectedAllergies.clear();
    selectedMedicalConditions.clear();
    selectedMagicListItems.clear();
    selectedAvatar.value = null;
    nameController.clear();
    dateOfBirth.value = null;
    magicList.clear();
    developer.log('🔄 Selections reset', name: 'ProfileSetupController');
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}