// lib/core/controllers/profile_controller.dart

import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../global/model/profile_model.dart';
import '../services/profile_service.dart';
import '../../utils/storage/storage_helper.dart';

class ProfileController extends GetxController {
  // Observable variables
  final Rx<ProfileModel?> activeProfile = Rx<ProfileModel?>(null);
  final RxList<ProfileModel> allProfiles = <ProfileModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // User settings
  final RxString country = 'Mexico'.obs;
  final RxString language = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveProfile();
    fetchAllProfiles();
  }

  /// 7.1 - Fetch Active Profile
  Future<void> fetchActiveProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      developer.log('🔍 Fetching active profile...', name: 'ProfileController');

      final profile = await ProfileService.getActiveProfile();

      if (profile != null) {
        activeProfile.value = profile;
        developer.log('✅ Active profile loaded: ${profile.profileName}',
            name: 'ProfileController');
      } else {
        errorMessage.value = 'No active profile found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load active profile: $e';
      developer.log('❌ Error: $e', name: 'ProfileController');
    } finally {
      isLoading.value = false;
    }
  }

  /// 7.2 - Fetch All User Profiles
  Future<void> fetchAllProfiles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      developer.log('🔍 Fetching all profiles...', name: 'ProfileController');

      final userProfiles = await ProfileService.getAllProfiles();

      if (userProfiles != null) {
        allProfiles.value = userProfiles.profiles;
        country.value = userProfiles.country ?? 'Mexico';
        language.value = userProfiles.language ?? 'en';

        developer.log('✅ Loaded ${allProfiles.length} profiles',
            name: 'ProfileController');
      } else {
        errorMessage.value = 'No profiles found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load profiles: $e';
      developer.log('❌ Error: $e', name: 'ProfileController');
    } finally {
      isLoading.value = false;
    }
  }

  /// 7.2 - Switch Profile
  Future<bool> switchProfile(int profileId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      developer.log('🔄 Switching to profile ID: $profileId',
          name: 'ProfileController');

      final success = await ProfileService.switchProfile(profileId);

      if (success) {
        // Refresh data after switching
        await fetchActiveProfile();
        await fetchAllProfiles();

        developer.log('✅ Profile switched successfully',
            name: 'ProfileController');

        return true;
      } else {
        errorMessage.value = 'Failed to switch profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error switching profile: $e';
      developer.log('❌ Error: $e', name: 'ProfileController');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 7.3 - Update Profile
  Future<bool> updateProfile({
    required int profileId,
    String? profileName,
    String? avatar,
    String? newCountry,
    String? newLanguage,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      developer.log('📝 Updating profile...', name: 'ProfileController');

      final success = await ProfileService.updateProfile(
        profileId: profileId,
        profileName: profileName,
        avatar: avatar,
        country: newCountry,
        language: newLanguage,
      );

      if (success) {
        // Update local state
        if (newCountry != null) country.value = newCountry;
        if (newLanguage != null) language.value = newLanguage;

        // Refresh data
        await fetchActiveProfile();
        await fetchAllProfiles();

        developer.log('✅ Profile updated successfully',
            name: 'ProfileController');

        return true;
      } else {
        errorMessage.value = 'Failed to update profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      developer.log('❌ Error: $e', name: 'ProfileController');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Profile with Image
  Future<bool> updateProfileWithImage({
    required int profileId,
    String? profileName,
    File? profileImage,
    Uint8List? webProfileImage,
    String? newCountry,
    String? newLanguage,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      developer.log('📝 Updating profile with image...', name: 'ProfileController');

      // Step 1: Upload image if provided
      if (profileImage != null || webProfileImage != null) {
        final imageSuccess = await ProfileService.updateProfileWithImage(
          profileId: profileId,
          profileName: profileName,
          profileImage: profileImage,
          webProfileImage: webProfileImage,
        );

        if (!imageSuccess) {
          errorMessage.value = 'Failed to upload profile image';
          return false;
        }
      }

      // Step 2: Update other profile fields (name, country, language) via PATCH
      if (profileName != null || newCountry != null || newLanguage != null) {
        final updateSuccess = await ProfileService.updateProfile(
          profileId: profileId,
          profileName: profileName,
          country: newCountry,
          language: newLanguage,
        );

        if (!updateSuccess) {
          errorMessage.value = 'Failed to update profile details';
          return false;
        }
      }

      // Update local state
      if (newCountry != null) country.value = newCountry;
      if (newLanguage != null) language.value = newLanguage;

      // Refresh data
      await fetchActiveProfile();
      await fetchAllProfiles();

      developer.log('✅ Profile with image updated successfully',
          name: 'ProfileController');

      return true;
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      developer.log('❌ Error: $e', name: 'ProfileController');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout - Clear all data
  Future<void> logout() async {
    try {
      developer.log('🚪 Logging out...', name: 'ProfileController');

      // Clear storage
      await StorageHelper.clearAll();

      // Clear local state
      activeProfile.value = null;
      allProfiles.clear();

      developer.log('✅ Logged out successfully', name: 'ProfileController');
    } catch (e) {
      developer.log('❌ Error during logout: $e', name: 'ProfileController');
    }
  }

  /// Get profile by ID
  ProfileModel? getProfileById(int id) {
    try {
      return allProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get inactive profiles (for "Others Profile" section)
  List<ProfileModel> getInactiveProfiles() {
    return allProfiles.where((profile) => !profile.isActive).toList();
  }
}