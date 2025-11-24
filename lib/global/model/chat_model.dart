// lib/global/model/chat_model.dart

/// Message Model
class ChatMessage {
  final int id;
  final int conversation;
  final String content;
  final String sender; // "user" or "ai"
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.conversation,
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      conversation: json['conversation'] as int,
      content: json['content'] as String,
      sender: json['sender'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversation,
      'content': content,
      'sender': sender,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isUser => sender == 'user';
  bool get isAi => sender == 'ai';
}

/// Profile Info in Conversation
class ConversationProfile {
  final int id;
  final String profileName;

  ConversationProfile({
    required this.id,
    required this.profileName,
  });

  factory ConversationProfile.fromJson(Map<String, dynamic> json) {
    return ConversationProfile(
      id: json['id'] as int,
      profileName: json['profile_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_name': profileName,
    };
  }
}

/// Conversation Model
class Conversation {
  final int id;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ConversationProfile profile;
  final List<ChatMessage> messages;

  Conversation({
    required this.id,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      summary: json['summary'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      profile: ConversationProfile.fromJson(json['profile'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'profile': profile.toJson(),
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }

  /// Get last message content for preview
  String get lastMessagePreview {
    if (messages.isEmpty) return 'No messages yet';
    return messages.last.content.length > 50
        ? '${messages.last.content.substring(0, 50)}...'
        : messages.last.content;
  }

  /// Get message count
  int get messageCount => messages.length;
}

/// Send Message Request
class SendMessageRequest {
  final String message;
  final int conversationId;

  SendMessageRequest({
    required this.message,
    required this.conversationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'conversation_id': conversationId,
    };
  }
}