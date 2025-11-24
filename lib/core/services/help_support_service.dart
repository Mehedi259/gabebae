// lib/core/services/help_support_service.dart

import 'dart:developer' as developer;
import 'api_service.dart';

class HelpSupportService {
  /// Send support message
  static Future<Map<String, dynamic>?> sendSupportMessage({
    required String email,
    required String subject,
    required String messageDetails,
  }) async {
    try {
      developer.log('📤 Sending support message...', name: 'HelpSupportService');

      final body = {
        "email": email,
        "subject": subject,
        "message_details": messageDetails,
      };

      final response = await ApiService.postRequest('/support/', body: body);

      developer.log('✅ Support message sent successfully', name: 'HelpSupportService');
      return response;
    } catch (e) {
      developer.log('❌ Error sending support message: $e', name: 'HelpSupportService');
      rethrow;
    }
  }
}