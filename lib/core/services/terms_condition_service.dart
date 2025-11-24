// lib/core/services/terms_condition_service.dart

import 'dart:developer' as developer;
import '../../global/model/terms_condition_model.dart';
import 'api_service.dart';

class TermsConditionService {
  /// Get Terms and Conditions content
  static Future<TermsConditionModel?> getTermsCondition() async {
    try {
      developer.log('📤 Fetching Terms & Conditions...', name: 'TermsConditionService');

      final response = await ApiService.getRequest('/terms/');

      if (response != null) {
        final terms = TermsConditionModel.fromJson(response);
        developer.log('✅ Terms & Conditions fetched successfully', name: 'TermsConditionService');
        return terms;
      }

      return null;
    } catch (e) {
      developer.log('❌ Error fetching Terms & Conditions: $e', name: 'TermsConditionService');
      rethrow;
    }
  }
}