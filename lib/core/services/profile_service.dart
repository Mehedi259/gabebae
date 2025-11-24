// lib/core/services/profile_service.dart

import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../global/model/profile_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class ProfileService {
  /// 7.1 - Get Active Profile
  /// GET /api/profiles/active/
  static Future<ProfileModel?> getActiveProfile() async {
    try {
      developer.log('🔍 Fetching active profile...', name: 'ProfileService');

      final response = await ApiService.getRequest(ApiConstants.activeProfile);

      if (response != null) {
        developer.log('✅ Active profile fetched successfully', name: 'ProfileService');
        return ProfileModel.fromJson(response);
      }

      return null;
    } catch (e) {
      developer.log('❌ Error fetching active profile: $e', name: 'ProfileService');
      rethrow;
    }
  }

  /// 7.2 - Get All User Profiles
  /// GET /api/users/me/
  static Future<UserProfilesModel?> getAllProfiles() async {
    try {
      developer.log('🔍 Fetching all user profiles...', name: 'ProfileService');

      final response = await ApiService.getRequest('/users/me/');

      if (response != null) {
        developer.log('✅ All profiles fetched successfully', name: 'ProfileService');
        return UserProfilesModel.fromJson(response);
      }

      return null;
    } catch (e) {
      developer.log('❌ Error fetching all profiles: $e', name: 'ProfileService');
      rethrow;
    }
  }

  /// 7.2 - Switch Active Profile
  /// PATCH /api/users/me/
  static Future<bool> switchProfile(int profileId) async {
    try {
      developer.log('🔄 Switching to profile ID: $profileId', name: 'ProfileService');

      final body = {
        "profiles": [
          {
            "id": profileId,
            "is_active": true
          }
        ]
      };

      final response = await ApiService.patchRequest('/users/me/', body: body);

      if (response != null) {
        developer.log('✅ Profile switched successfully', name: 'ProfileService');
        return true;
      }

      return false;
    } catch (e) {
      developer.log('❌ Error switching profile: $e', name: 'ProfileService');
      rethrow;
    }
  }

  /// 7.3 - Update Profile (Name, Avatar, Country, Language)
  /// PATCH /api/users/me/
  static Future<bool> updateProfile({
    required int profileId,
    String? profileName,
    String? avatar,
    String? country,
    String? language,
  }) async {
    try {
      developer.log('📝 Updating profile ID: $profileId', name: 'ProfileService');

      final Map<String, dynamic> body = {};

      // Profile update
      final profileData = <String, dynamic>{
        "id": profileId,
        "is_active": true,
      };

      if (profileName != null) profileData["profile_name"] = profileName;
      if (avatar != null) profileData["avatar"] = avatar;

      body["profiles"] = [profileData];

      // User settings update
      if (country != null) body["country"] = country;
      if (language != null) body["language"] = language;

      final response = await ApiService.patchRequest('/users/me/', body: body);

      if (response != null) {
        developer.log('✅ Profile updated successfully', name: 'ProfileService');
        return true;
      }

      return false;
    } catch (e) {
      developer.log('❌ Error updating profile: $e', name: 'ProfileService');
      rethrow;
    }
  }

  /// Update Profile with Image Upload
  /// PUT /api/profiles/{id}/
  static Future<bool> updateProfileWithImage({
    required int profileId,
    String? profileName,
    File? profileImage,
    Uint8List? webProfileImage,
  }) async {
    try {
      developer.log('📝 Updating profile with image, ID: $profileId',
          name: 'ProfileService');

      // Get user ID from storage
      final userId = await StorageHelper.getUserId();

      if (userId == null) {
        developer.log('❌ User ID not found in storage', name: 'ProfileService');
        throw Exception('User ID is required');
      }

      final fields = <String, String>{
        'user': userId.toString(), // ✅ CRITICAL: Add user field
      };

      if (profileName != null && profileName.isNotEmpty) {
        fields['profile_name'] = profileName;
      }

      final files = <String, File>{};
      final webFiles = <String, Uint8List>{};

      if (kIsWeb && webProfileImage != null) {
        webFiles['profile_image'] = webProfileImage;
      } else if (!kIsWeb && profileImage != null) {
        files['profile_image'] = profileImage;
      }

      final response = await ApiService.putMultipartRequest(
        '/profiles/$profileId/',
        fields: fields,
        files: files.isNotEmpty ? files : null,
        webFiles: webFiles.isNotEmpty ? webFiles : null,
      );

      if (response != null) {
        developer.log('✅ Profile with image updated successfully',
            name: 'ProfileService');
        return true;
      }

      return false;
    } catch (e) {
      developer.log('❌ Error updating profile with image: $e',
          name: 'ProfileService');
      rethrow;
    }
  }
}