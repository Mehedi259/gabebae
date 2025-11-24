// lib/core/services/chat_service.dart

import 'dart:developer' as developer;
import '../../global/model/chat_model.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class ChatService {
  /// Create New Conversation
  static Future<Conversation> createNewConversation() async {
    try {
      developer.log('💬 Creating new conversation', name: 'ChatService');

      final response = await ApiService.postRequest(
        ApiConstants.newConversation,
        body: {}, // Empty body as per API spec
      );

      final conversation = Conversation.fromJson(response);

      developer.log('✅ New conversation created: ID ${conversation.id}',
          name: 'ChatService');
      return conversation;
    } catch (e) {
      developer.log('❌ Error creating conversation: $e', name: 'ChatService');
      rethrow;
    }
  }

  /// Send Message
  static Future<Conversation> sendMessage(SendMessageRequest request) async {
    try {
      developer.log(
          '📤 Sending message to conversation ${request.conversationId}',
          name: 'ChatService');

      final response = await ApiService.postRequest(
        ApiConstants.sendMessage,
        body: request.toJson(),
      );

      final conversation = Conversation.fromJson(response);

      developer.log(
          '✅ Message sent successfully. Total messages: ${conversation.messages.length}',
          name: 'ChatService');
      return conversation;
    } catch (e) {
      developer.log('❌ Error sending message: $e', name: 'ChatService');
      rethrow;
    }
  }

  /// Get All Conversations (Chat History)
  static Future<List<Conversation>> getAllConversations() async {
    try {
      developer.log('📜 Fetching all conversations', name: 'ChatService');

      final response = await ApiService.getRequest(
        ApiConstants.conversations,
      );

      final List<dynamic> data = response as List<dynamic>;
      final conversations = data
          .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
          .toList();

      developer.log('✅ Fetched ${conversations.length} conversations',
          name: 'ChatService');
      return conversations;
    } catch (e) {
      developer.log('❌ Error fetching conversations: $e', name: 'ChatService');
      rethrow;
    }
  }

  /// Delete Conversation
  static Future<void> deleteConversation(int conversationId) async {
    try {
      developer.log('🗑️ Deleting conversation $conversationId',
          name: 'ChatService');

      await ApiService.deleteRequest(
        ApiConstants.deleteConversation(conversationId),
      );

      developer.log('✅ Conversation deleted successfully',
          name: 'ChatService');
    } catch (e) {
      developer.log('❌ Error deleting conversation: $e', name: 'ChatService');
      rethrow;
    }
  }
}