// lib/core/services/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;


import '../../global/model/user_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';

class UserService {
  /// Get Current User Profile Data
  static Future<UserMeResponse> getUserMe() async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.usersMe}");

      developer.log('📤 GET User Me Request to: $uri', name: 'UserService');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token?.trim() ?? ""}',
        },
      );

      developer.log('📥 User Me Response Status: ${response.statusCode}',
          name: 'UserService');
      developer.log('📥 User Me Response Body: ${response.body}',
          name: 'UserService');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserMeResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch user data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      developer.log('❌ User Me Fetch Error: $e', name: 'UserService');
      throw Exception('Error fetching user data: $e');
    }
  }

  /// Get Active Profile Name and User ID for Combo API
  /// Returns: { 'userId': 1, 'profileName': 'saifur' }
  static Future<Map<String, dynamic>> getActiveProfile() async {
    try {
      final userMe = await getUserMe();
      final activeProfile = userMe.activeProfile;

      if (activeProfile == null) {
        throw Exception('No active profile found');
      }

      // Return User ID (not Profile ID) and Active Profile Name
      return {
        'userId': userMe.id,  // Main user ID (e.g., 1)
        'profileName': activeProfile.profileName,  // Active profile name (e.g., "saifur")
        'profileId': activeProfile.id,  // Profile ID for reference (e.g., 21)
        'avatar': activeProfile.avatar,
        'profileImage': activeProfile.profileImage,
      };
    } catch (e) {
      developer.log('❌ Active Profile Fetch Error: $e', name: 'UserService');
      rethrow;
    }
  }
}