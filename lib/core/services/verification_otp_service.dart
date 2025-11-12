//lib/core/services/verification_otp_service.dart
import 'dart:developer' as developer;
import '../../utils/storage/storage_helper.dart';
import 'api_service.dart';

class VerificationOtpService {
  /// Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String language,
  }) async {
    try {
      developer.log('🔐 Verifying OTP for: $email', name: 'VerificationOtpService');

      final response = await ApiService.postRequest(
        '/auth/verify-otp/',
        body: {
          'email': email,
          'otp': otp,
          'language': language,
        },
      );

      // Store tokens
      if (response['access'] != null) {
        await StorageHelper.saveToken(response['access']);
        developer.log('✅ Token saved successfully', name: 'VerificationOtpService');
      }

      if (response['refresh'] != null) {
        await StorageHelper.saveRefreshToken(response['refresh']);
        developer.log('✅ Refresh token saved', name: 'VerificationOtpService');
      }

      developer.log('✅ OTP Verification Success', name: 'VerificationOtpService');
      return {
        'success': true,
        'user': response['user'],
        'message': 'Login successful',
      };
    } catch (e) {
      developer.log('❌ OTP Verification Failed: $e', name: 'VerificationOtpService');
      return {
        'success': false,
        'message': 'Invalid OTP. Please try again.',
      };
    }
  }
}