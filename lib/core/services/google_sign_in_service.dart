import 'dart:developer' as developer;
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class GoogleSignInService {
  /// ✅ IMPORTANT:
  /// iOS → clientId দেওয়া যাবে না (Info.plist ব্যবহার করবে)
  /// Android → SHA-1 দিয়ে auto handle হয়
  /// Web হলে আলাদা করে clientId দিতে হয়
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  /// ============================
  /// Sign in with Google
  /// ============================
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      developer.log('🔐 Starting Google Sign In...', name: 'GoogleSignInService');

      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log(
          '❌ Google Sign In cancelled by user',
          name: 'GoogleSignInService',
        );
        return {
          'success': false,
          'message': 'Sign in cancelled',
        };
      }

      developer.log(
        '✅ Google Sign In successful: ${googleUser.email}',
        name: 'GoogleSignInService',
      );

      /// Backend এ email পাঠানো
      final response = await _sendToBackend(googleUser.email);

      if (response['success'] == true) {
        await StorageHelper.saveToken(response['access']);
        await StorageHelper.saveRefreshToken(response['refresh']);
        await StorageHelper.saveUserEmail(googleUser.email);

        developer.log(
          '✅ Google authentication completed',
          name: 'GoogleSignInService',
        );

        return {
          'success': true,
          'message': 'Successfully signed in with Google',
          'data': response,
        };
      } else {
        return response;
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Google Sign In Error: $e',
        name: 'GoogleSignInService',
      );
      developer.log(
        'Stack trace: $stackTrace',
        name: 'GoogleSignInService',
      );

      return {
        'success': false,
        'message': 'Failed to sign in with Google',
      };
    }
  }

  /// ============================
  /// Send Google user to backend
  /// ============================
  static Future<Map<String, dynamic>> _sendToBackend(String email) async {
    try {
      developer.log(
        '📤 Sending Google user to backend: $email',
        name: 'GoogleSignInService',
      );

      final response = await ApiService.postRequest(
        ApiConstants.googleAuth,
        body: {
          'email': email,
        },
      );

      developer.log(
        '✅ Backend response received',
        name: 'GoogleSignInService',
      );

      return {
        'success': true,
        'created': response['created'] ?? false,
        'access': response['access'],
        'refresh': response['refresh'],
      };
    } catch (e) {
      developer.log(
        '❌ Backend Error: $e',
        name: 'GoogleSignInService',
      );

      return {
        'success': false,
        'message': 'Backend authentication failed',
      };
    }
  }

  /// ============================
  /// Sign out
  /// ============================
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await StorageHelper.clearAll();

      developer.log(
        '✅ Google Sign Out successful',
        name: 'GoogleSignInService',
      );
    } catch (e) {
      developer.log(
        '❌ Google Sign Out Error: $e',
        name: 'GoogleSignInService',
      );
    }
  }

  /// ============================
  /// Check signed in
  /// ============================
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// ============================
  /// Current user
  /// ============================
  static GoogleSignInAccount? get currentUser =>
      _googleSignIn.currentUser;
}
