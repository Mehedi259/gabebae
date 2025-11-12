//lib/core/services/sign_in_service.dart
import 'dart:developer' as developer;
import 'api_service.dart';

class SignInService {
  /// Request OTP
  static Future<Map<String, dynamic>> requestOtp(String email) async {
    try {
      developer.log('📧 Requesting OTP for: $email', name: 'SignInService');

      final response = await ApiService.postRequest(
        '/auth/request-otp/',
        body: {'email': email},
      );

      developer.log('✅ OTP Request Success', name: 'SignInService');
      return {
        'success': true,
        'message': response['detail'] ?? 'OTP sent successfully.',
      };
    } catch (e) {
      developer.log('❌ OTP Request Failed: $e', name: 'SignInService');
      return {
        'success': false,
        'message': 'Failed to send OTP. Please try again.',
      };
    }
  }
}