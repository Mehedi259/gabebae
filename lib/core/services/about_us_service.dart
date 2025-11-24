// lib/core/services/about_us_service.dart

import 'dart:developer' as developer;
import '../../global/model/about_us_model.dart';
import 'api_service.dart';

class AboutUsService {
  /// Get About Us content
  static Future<AboutUsModel?> getAboutUs() async {
    try {
      developer.log('📤 Fetching About Us...', name: 'AboutUsService');

      final response = await ApiService.getRequest('/about-us/');

      if (response != null) {
        final aboutUs = AboutUsModel.fromJson(response);
        developer.log('✅ About Us fetched successfully', name: 'AboutUsService');
        return aboutUs;
      }

      return null;
    } catch (e) {
      developer.log('❌ Error fetching About Us: $e', name: 'AboutUsService');
      rethrow;
    }
  }
}