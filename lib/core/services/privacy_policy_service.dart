// lib/core/services/privacy_policy_service.dart

import 'dart:developer' as developer;
import '../../global/model/privacy_policy_model.dart';
import 'api_service.dart';

class PrivacyPolicyService {
  /// Get Privacy Policy content
  static Future<PrivacyPolicyModel?> getPrivacyPolicy() async {
    try {
      developer.log('📤 Fetching Privacy Policy...', name: 'PrivacyPolicyService');

      final response = await ApiService.getRequest('/privacy-policy/');

      if (response != null) {
        final privacyPolicy = PrivacyPolicyModel.fromJson(response);
        developer.log('✅ Privacy Policy fetched successfully', name: 'PrivacyPolicyService');
        return privacyPolicy;
      }

      return null;
    } catch (e) {
      developer.log('❌ Error fetching Privacy Policy: $e', name: 'PrivacyPolicyService');
      rethrow;
    }
  }
}