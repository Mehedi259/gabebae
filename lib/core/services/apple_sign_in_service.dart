import 'dart:developer' as developer;
import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class AppleSignInService {
  /// Check if Apple Sign In is available
  static Future<bool> isAvailable() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await SignInWithApple.isAvailable();
    }
    return false;
  }

  /// Sign in with Apple
  static Future<Map<String, dynamic>> signInWithApple() async {
    try {
      developer.log('🍎 Starting Apple Sign In...', name: 'AppleSignInService');

      final isAvailable = await AppleSignInService.isAvailable();
      if (!isAvailable) {
        return {
          'success': false,
          'message': 'Apple Sign In is not available on this device',
        };
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      developer.log('✅ Apple Sign In successful', name: 'AppleSignInService');

      String? email = credential.email;

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

      final response = await _sendToBackend(
        idToken: credential.identityToken ?? '',
        email: email,
      );

      if (response['success']) {
        // ✅ Save all data
        await StorageHelper.saveToken(response['access']);
        await StorageHelper.saveRefreshToken(response['refresh']);
        await StorageHelper.saveUserEmail(email);


        if (response['user_id'] != null) {
          await StorageHelper.saveUserId(response['user_id']);
          developer.log('✅ User ID saved: ${response['user_id']}', name: 'AppleSignInService');
        }

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

      int? userId;
      if (response['user'] != null && response['user']['id'] != null) {
        userId = response['user']['id'] as int;
      }

      return {
        'success': true,
        'created': response['created'] ?? false,
        'access': response['access'],
        'refresh': response['refresh'],
        'user_id': userId,
      };
    } catch (e) {
      developer.log('❌ Backend Error: $e', name: 'AppleSignInService');
      return {
        'success': false,
        'message': 'Failed to authenticate with server: ${e.toString()}',
      };
    }
  }

  /// Sign out from Apple
  static Future<void> signOut() async {
    try {
      await StorageHelper.clearAll();
      developer.log('✅ Apple Sign Out successful', name: 'AppleSignInService');
    } catch (e) {
      developer.log('❌ Apple Sign Out Error: $e', name: 'AppleSignInService');
    }
  }
}