// lib/core/controllers/help_support_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/help_support_service.dart';

class HelpSupportController extends GetxController {
  final titleController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  /// Validate form fields
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter a title';
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }

    if (messageController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your message';
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  /// Send support message
  Future<bool> sendSupportMessage() async {
    if (!validateForm()) {
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await HelpSupportService.sendSupportMessage(
        email: emailController.text.trim(),
        subject: titleController.text.trim(),
        messageDetails: messageController.text.trim(),
      );

      if (response != null) {
        successMessage.value = 'Your message has been sent successfully!';

        // Clear form after successful submission
        titleController.clear();
        emailController.clear();
        messageController.clear();

        return true;
      } else {
        errorMessage.value = 'Failed to send message. Please try again.';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all messages
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
}