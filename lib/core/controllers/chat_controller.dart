// lib/core/controllers/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../global/model/chat_model.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  // Loading states
  final RxBool isLoadingConversation = false.obs;
  final RxBool isSendingMessage = false.obs;
  final RxBool isLoadingHistory = false.obs;

  // Current conversation
  final Rx<Conversation?> currentConversation = Rx<Conversation?>(null);

  // Chat history
  final RxList<Conversation> conversationHistory = <Conversation>[].obs;

  // Message input
  final TextEditingController messageController = TextEditingController();

  /// Create New Conversation
  Future<bool> createNewConversation() async {
    try {
      isLoadingConversation.value = true;
      developer.log('🆕 Creating new conversation', name: 'ChatController');

      final conversation = await ChatService.createNewConversation();
      currentConversation.value = conversation;

      developer.log('✅ Conversation created: ID ${conversation.id}',
          name: 'ChatController');
      return true;
    } catch (e) {
      developer.log('❌ Error creating conversation: $e',
          name: 'ChatController');
      _showError('Failed to start new conversation');
      return false;
    } finally {
      isLoadingConversation.value = false;
    }
  }

  /// Send Message
  Future<bool> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      _showError('Please enter a message');
      return false;
    }

    if (currentConversation.value == null) {
      _showError('No active conversation');
      return false;
    }

    try {
      isSendingMessage.value = true;
      developer.log('📤 Sending message', name: 'ChatController');

      final request = SendMessageRequest(
        message: message.trim(),
        conversationId: currentConversation.value!.id,
      );

      final updatedConversation = await ChatService.sendMessage(request);
      currentConversation.value = updatedConversation;

      // Clear message input
      messageController.clear();

      developer.log('✅ Message sent successfully', name: 'ChatController');
      return true;
    } catch (e) {
      developer.log('❌ Error sending message: $e', name: 'ChatController');
      _showError('Failed to send message');
      return false;
    } finally {
      isSendingMessage.value = false;
    }
  }

  /// Load Chat History
  Future<void> loadChatHistory() async {
    try {
      isLoadingHistory.value = true;
      developer.log('📜 Loading chat history', name: 'ChatController');

      final conversations = await ChatService.getAllConversations();
      conversationHistory.value = conversations;

      developer.log('✅ Loaded ${conversations.length} conversations',
          name: 'ChatController');
    } catch (e) {
      developer.log('❌ Error loading history: $e', name: 'ChatController');
      _showError('Failed to load chat history');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Delete Conversation
  Future<bool> deleteConversation(int conversationId) async {
    try {
      developer.log('🗑️ Deleting conversation $conversationId',
          name: 'ChatController');

      await ChatService.deleteConversation(conversationId);

      // Remove from history
      conversationHistory
          .removeWhere((conversation) => conversation.id == conversationId);

      // If current conversation is deleted, clear it
      if (currentConversation.value?.id == conversationId) {
        currentConversation.value = null;
      }

      _showSuccess('Chat deleted successfully');
      developer.log('✅ Conversation deleted', name: 'ChatController');
      return true;
    } catch (e) {
      developer.log('❌ Error deleting conversation: $e',
          name: 'ChatController');
      _showError('Failed to delete chat');
      return false;
    }
  }

  /// Load Specific Conversation
  void loadConversation(Conversation conversation) {
    currentConversation.value = conversation;
    developer.log('📖 Loaded conversation: ${conversation.id}',
        name: 'ChatController');
  }

  /// Get Messages for UI
  List<ChatMessage> get messages =>
      currentConversation.value?.messages ?? [];

  /// Check if has active conversation
  bool get hasActiveConversation => currentConversation.value != null;

  /// Show Error
  void _showError(String msg) {
    developer.log('❌ Error: $msg', name: 'ChatController');

    try {
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      developer.log('⚠️ Could not show snackbar: $e', name: 'ChatController');
    }
  }

  /// Show Success
  void _showSuccess(String msg) {
    developer.log('✅ Success: $msg', name: 'ChatController');

    try {
      Get.snackbar(
        'Success',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      developer.log('⚠️ Could not show snackbar: $e', name: 'ChatController');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}