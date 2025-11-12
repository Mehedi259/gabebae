//lib/core/controllers/sign_in_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sign_in_service.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  /// Request OTP
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

    if (result['success']) {
      _showSnackBar(context, result['message'], isError: false);
      return true;
    } else {
      _showSnackBar(context, result['message']);
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = true}) {
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