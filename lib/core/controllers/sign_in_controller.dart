import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sign_in_service.dart';
import '../services/google_sign_in_service.dart';
import '../services/apple_sign_in_service.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isAppleLoading = false.obs;

  /// ============================
  /// Email OTP Sign In
  /// ============================
  Future<bool> requestOtp(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar(context, 'Please enter your email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      _showSnackBar(context, 'Please enter a valid email');
      return false;
    }

    isLoading.value = true;

    final result = await SignInService.requestOtp(email);

    isLoading.value = false;

    if (result['success'] == true) {
      _showSnackBar(
        context,
        result['message'] ?? 'OTP sent successfully',
        isError: false,
      );
      return true;
    } else {
      _showSnackBar(context, result['message'] ?? 'Failed to send OTP');
      return false;
    }
  }

  /// ============================
  /// Google Sign In
  /// ============================
  Future<Map<String, dynamic>> signInWithGoogle(BuildContext context) async {
    isGoogleLoading.value = true;

    final result = await GoogleSignInService.signInWithGoogle();

    isGoogleLoading.value = false;

    if (result['success'] == true) {
      _showSnackBar(
        context,
        result['message'] ?? 'Signed in with Google',
        isError: false,
      );
    } else {
      if (result['message'] != 'Sign in cancelled') {
        _showSnackBar(context, result['message'] ?? 'Google sign in failed');
      }
    }

    return result;
  }

  /// ============================
  /// Apple Sign In
  /// ============================
  Future<Map<String, dynamic>> signInWithApple(BuildContext context) async {
    final isAvailable = await AppleSignInService.isAvailable();

    if (!isAvailable) {
      _showSnackBar(
        context,
        'Apple Sign In is not available on this device',
      );
      return {
        'success': false,
        'message': 'Apple Sign In not available',
      };
    }

    isAppleLoading.value = true;

    final result = await AppleSignInService.signInWithApple();

    isAppleLoading.value = false;

    if (result['success'] == true) {
      _showSnackBar(
        context,
        result['message'] ?? 'Signed in with Apple',
        isError: false,
      );
    } else {
      if (result['message'] != 'Sign in cancelled') {
        _showSnackBar(context, result['message'] ?? 'Apple sign in failed');
      }
    }

    return result;
  }

  /// ============================
  /// SnackBar Helper
  /// ============================
  void _showSnackBar(
      BuildContext context,
      String message, {
        bool isError = true,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
