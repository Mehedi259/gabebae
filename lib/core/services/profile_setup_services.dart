// lib/core/services/profile_setup_services.dart

import 'dart:developer' as developer;
import '../../global/model/profile_setup_model.dart';
import 'api_service.dart';

class ProfileSetupService {
  /// Get Eating Styles
  static Future<List<EatingStyle>> getEatingStyles() async {
    try {
      developer.log('🍽️ Fetching eating styles', name: 'ProfileSetupService');

      final response = await ApiService.getRequest('/eating-style/');

      final List<dynamic> data = response as List<dynamic>;
      final eatingStyles = data.map((json) => EatingStyle.fromJson(json)).toList();

      developer.log('✅ Fetched ${eatingStyles.length} eating styles', name: 'ProfileSetupService');
      return eatingStyles;
    } catch (e) {
      developer.log('❌ Error fetching eating styles: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Get Allergies
  static Future<List<Allergy>> getAllergies() async {
    try {
      developer.log('🥜 Fetching allergies', name: 'ProfileSetupService');

      final response = await ApiService.getRequest('/allergies/');

      final List<dynamic> data = response as List<dynamic>;
      final allergies = data.map((json) => Allergy.fromJson(json)).toList();

      developer.log('✅ Fetched ${allergies.length} allergies', name: 'ProfileSetupService');
      return allergies;
    } catch (e) {
      developer.log('❌ Error fetching allergies: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Get Medical Conditions
  static Future<List<MedicalCondition>> getMedicalConditions() async {
    try {
      developer.log('🏥 Fetching medical conditions', name: 'ProfileSetupService');

      final response = await ApiService.getRequest('/medical-conditions/');

      final List<dynamic> data = response as List<dynamic>;
      final conditions = data.map((json) => MedicalCondition.fromJson(json)).toList();

      developer.log('✅ Fetched ${conditions.length} medical conditions', name: 'ProfileSetupService');
      return conditions;
    } catch (e) {
      developer.log('❌ Error fetching medical conditions: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Get Avatars
  static Future<List<Avatar>> getAvatars() async {
    try {
      developer.log('🎭 Fetching avatars', name: 'ProfileSetupService');

      final response = await ApiService.getRequest('/avatars/');

      final List<dynamic> data = response as List<dynamic>;
      final avatars = data.map((json) => Avatar.fromJson(json)).toList();

      developer.log('✅ Fetched ${avatars.length} avatars', name: 'ProfileSetupService');
      return avatars;
    } catch (e) {
      developer.log('❌ Error fetching avatars: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Generate Magic List - FIXED to use correct field name
  static Future<MagicListResponse> generateMagicList({
    required List<EatingStyleSelection> eatingStyles,
    required List<String> allergies,
    required List<String> medicalConditions,
  }) async {
    try {
      developer.log('✨ Generating magic list', name: 'ProfileSetupService');

      final body = {
        'eating_style': eatingStyles.map((e) => e.toMagicListJson()).toList(), // ✅ Fixed: using toMagicListJson()
        'allergies': allergies,
        'medical_conditions': medicalConditions,
      };

      developer.log('📦 Magic List Body: $body', name: 'ProfileSetupService');

      final response = await ApiService.postRequest(
        '/magic-list/',
        body: body,
      );

      final magicList = MagicListResponse.fromJson(response);

      developer.log('✅ Magic list generated with ${magicList.magicList.length} items',
          name: 'ProfileSetupService');
      return magicList;
    } catch (e) {
      developer.log('❌ Error generating magic list: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Get Active Profile
  static Future<Map<String, dynamic>> getActiveProfile() async {
    try {
      developer.log('🔍 Fetching active profile', name: 'ProfileSetupService');

      final response = await ApiService.getRequest('/profiles/active/');

      developer.log('✅ Active profile fetched', name: 'ProfileSetupService');
      return response as Map<String, dynamic>;
    } catch (e) {
      developer.log('❌ Error fetching active profile: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Update Active Profile
  static Future<ProfileResponse> updateProfile(ProfileCreateRequest request) async {
    try {
      developer.log('🔄 Updating active profile: ${request.profileName}', name: 'ProfileSetupService');

      final response = await ApiService.patchRequest(
        '/profiles/active/',
        body: request.toJson(),
      );

      final profile = ProfileResponse.fromJson(response);

      developer.log('✅ Profile updated successfully: ${profile.profileName}',
          name: 'ProfileSetupService');
      return profile;
    } catch (e) {
      developer.log('❌ Error updating profile: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }

  /// Create Profile - uses toJson() with 'eating_style_name'
  static Future<ProfileResponse> createProfile(ProfileCreateRequest request) async {
    try {
      developer.log('👤 Creating profile: ${request.profileName}', name: 'ProfileSetupService');

      final response = await ApiService.postRequest(
        '/profiles/',
        body: request.toJson(),
      );

      final profile = ProfileResponse.fromJson(response);

      developer.log('✅ Profile created successfully: ${profile.profileName}',
          name: 'ProfileSetupService');
      return profile;
    } catch (e) {
      developer.log('❌ Error creating profile: $e', name: 'ProfileSetupService');
      rethrow;
    }
  }
}