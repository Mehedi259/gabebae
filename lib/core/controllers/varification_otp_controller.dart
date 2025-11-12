//lib/core/controllers/verification_otp_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/verification_otp_service.dart';

class VerificationOtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isOtpComplete = false.obs;

  String email = '';
  String language = 'English';

  void setEmail(String userEmail) {
    email = userEmail;
  }

  void setLanguage(String lang) {
    language = lang;
  }

  void onOtpChanged(String value) {
    isOtpComplete.value = value.length == 4;
  }

  /// Verify OTP
  Future<bool> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 4) {
      _showSnackBar(context, 'Please enter the 4-digit OTP');
      return false;
    }

    if (email.isEmpty) {
      _showSnackBar(context, 'Email not found. Please go back and try again.');
      return false;
    }

    isLoading.value = true;

    final result = await VerificationOtpService.verifyOtp(
      email: email,
      otp: otp,
      language: language,
    );

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
    otpController.dispose();
    super.onClose();
  }
}