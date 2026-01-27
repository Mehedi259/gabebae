import 'dart:developer' as developer;
import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class AppleSignInService {
  /// Check if Apple Sign In is available
  static Future<bool> isAvailable() async {
    // Apple Sign In is only available on iOS 13+ and macOS 10.15+
    if (Platform.isIOS || Platform.isMacOS) {
      return await SignInWithApple.isAvailable();
    }
    return false;
  }

  /// Sign in with Apple
  static Future<Map<String, dynamic>> signInWithApple() async {
    try {
      developer.log('🍎 Starting Apple Sign In...', name: 'AppleSignInService');

      // Check availability
      final isAvailable = await AppleSignInService.isAvailable();
      if (!isAvailable) {
        return {
          'success': false,
          'message': 'Apple Sign In is not available on this device',
        };
      }

      // Request credential from Apple
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      developer.log('✅ Apple Sign In successful', name: 'AppleSignInService');
      developer.log('Identity Token: ${credential.identityToken?.substring(0, 20)}...', name: 'AppleSignInService');
      developer.log('Email: ${credential.email ?? "not provided"}', name: 'AppleSignInService');

      // Extract email (Apple only provides it on first sign in)
      String? email = credential.email;

      // If email is null, try to get it from storage (for returning users)
      if (email == null || email.isEmpty) {
        email = await StorageHelper.getUserEmail();
        developer.log('⚠️ Email not provided by Apple, using stored: $email', name: 'AppleSignInService');
      }

      if (email == null || email.isEmpty) {
        return {
          'success': false,
          'message': 'Email not available. Please try signing in again or use a different method.',
        };
      }

      // Send to backend
      final response = await _sendToBackend(
        idToken: credential.identityToken ?? '',
        email: email,
      );

      if (response['success']) {
        // Save user data
        await StorageHelper.saveToken(response['access']);
        await StorageHelper.saveRefreshToken(response['refresh']);
        await StorageHelper.saveUserEmail(email);

        developer.log('✅ Apple authentication completed', name: 'AppleSignInService');
        return {
          'success': true,
          'message': 'Successfully signed in with Apple',
          'data': response,
        };
      } else {
        return response;
      }
    } catch (e, stackTrace) {
      developer.log('❌ Apple Sign In Error: $e', name: 'AppleSignInService');
      developer.log('Stack trace: $stackTrace', name: 'AppleSignInService');

      // Handle specific errors
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          return {
            'success': false,
            'message': 'Sign in cancelled',
          };
        } else if (e.code == AuthorizationErrorCode.failed) {
          return {
            'success': false,
            'message': 'Sign in failed. Please try again.',
          };
        }
      }

      return {
        'success': false,
        'message': 'Failed to sign in with Apple: ${e.toString()}',
      };
    }
  }

  /// Send Apple user data to backend
  static Future<Map<String, dynamic>> _sendToBackend({
    required String idToken,
    required String email,
  }) async {
    try {
      developer.log('📤 Sending Apple user to backend: $email', name: 'AppleSignInService');

      final response = await ApiService.postRequest(
        ApiConstants.appleAuth,
        body: {
          'id_token': idToken,
          'email': email,
        },
      );

      developer.log('✅ Backend response received', name: 'AppleSignInService');

      return {
        'success': true,
        'created': response['created'] ?? false,
        'access': response['access'],
        'refresh': response['refresh'],
      };
    } catch (e) {
      developer.log('❌ Backend Error: $e', name: 'AppleSignInService');
      return {
        'success': false,
        'message': 'Failed to authenticate with server: ${e.toString()}',
      };
    }
  }

  /// Sign out from Apple (just clear local data)
  static Future<void> signOut() async {
    try {
      await StorageHelper.clearAll();
      developer.log('✅ Apple Sign Out successful', name: 'AppleSignInService');
    } catch (e) {
      developer.log('❌ Apple Sign Out Error: $e', name: 'AppleSignInService');
    }
  }
}