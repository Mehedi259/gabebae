import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../presentation/widgets/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Chat Message Model
class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? quickReplies;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.quickReplies,
  });
}

// Chat History Model
class ChatHistory {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final bool isHighlighted;

  ChatHistory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isHighlighted = false,
  });
}

// Main Chat Screen
class MenuSidekickChatScreen extends StatefulWidget {
  const MenuSidekickChatScreen({super.key});

  @override
  State<MenuSidekickChatScreen> createState() => _MenuSidekickChatScreenState();
}

class _MenuSidekickChatScreenState extends State<MenuSidekickChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 2;

  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      message:
      "Hey sunshine 👋, I'm your Menu Sidekick — your foodie bestie who speaks fluent menu 🍽️. Whether you're scanning a menu, tweaking dishes to fit your lifestyle, or just curious about what's safe for you to eat, I've got your back 💛.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '2',
      message: "Is Tom Yum soup safe for me to eat?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      id: '3',
      message:
      "✨ Great choice! Tom Yum is naturally gluten-free 🌿\n\nIt's made with lemongrass, lime leaves, and chili. Perfect for your diet! 🌸",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      quickReplies: [
        "🌿 Is it cooked in butter or oil?",
        "🌱 Can I make this vegan?",
        "❓ What should I avoid here?"
      ],
    ),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go(RoutePath.home.addBasePath);
        break;
      case 1:
        context.go(RoutePath.scanMenu.addBasePath);
        break;
      case 2:
        context.go(RoutePath.askChatBot.addBasePath);
        break;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _messageController.text = "[Image: ${image.name}]";
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _messageController.text = "[File: ${result.files.first.name}]";
      });
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (val) {
          setState(() {
            _messageController.text = val.recognizedWords;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF4B5563)),
          onPressed: () => _showChatHistoryDrawer(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("✨", style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              "Menu Sidekick AI",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(width: 6),
            const Text("✨", style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4B5563)),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),

      body: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          /// CHAT MESSAGES
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          /// QUICK REPLIES (if available)
          if (_messages.isNotEmpty && _messages.last.quickReplies != null)
            _buildQuickReplies(_messages.last.quickReplies!),

          /// MESSAGE INPUT
          _buildMessageInput(),
        ],
      ),

      /// ✅ Custom Navigation integrated (index = 2)
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  Assets.images.robot.path,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF60A5FA) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isUser
                        ? null
                        : Border.all(color: const Color(0xFF669A59), width: 2),
                  ),
                  child: Text(
                    message.message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isUser ? Colors.white : const Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildQuickReplies(List<String> replies) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        itemBuilder: (context, index) {
          return Container(
            margin:
            EdgeInsets.only(right: index == replies.length - 1 ? 0 : 8),
            child: _buildQuickReplyChip(replies[index]),
          );
        },
      ),
    );
  }

  Widget _buildQuickReplyChip(String text) {
    Color bgColor = const Color(0xFF88A096);
    if (text.contains("vegan")) {
      bgColor = const Color(0xFFD4A574);
    } else if (text.contains("avoid")) {
      bgColor = const Color(0xFFC67C4E);
    }

    return GestureDetector(
      onTap: () => _sendQuickReply(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5DC),
        border: Border(top: BorderSide(color: Color(0xFFF5F5DC))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border:
                Border.all(color: const Color(0xFF669A59), width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Ask me anything about your meal...",
                  hintStyle: GoogleFonts.poppins(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file,
                        color: Color(0xFF6B7280)),
                    onPressed: _pickFile,
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF154452),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _pickImage,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF669A59),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: _startListening,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message:
          "That's a great question! Let me help you with that. Based on your dietary preferences, I'd recommend...",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _sendQuickReply(String text) {
    _sendMessage(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
              const Icon(Icons.delete_outline, color: Colors.red),
              title: Text("Delete This Chat",
                  style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete This Chat",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text("Are you sure you want to delete this conversation?",
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Chat deleted",
                        style: GoogleFonts.poppins())),
              );
            },
            child:
            Text("Delete", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChatHistoryDrawer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatHistoryScreen(),
      ),
    );
  }
}

// Chat History Screen
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ChatHistory> _chatHistory = [
    ChatHistory(
      id: '1',
      title: 'Italian Dinner Planning',
      subtitle: 'Need help with pasta recipes and wine pairing...',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isHighlighted: true,
    ),
    ChatHistory(
      id: '2',
      title: 'Italian Dinner Planning',
      subtitle: 'Looking for alternatives to wheat-based...',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                Assets.images.splash.path,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Menu Sidekick",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: const Color(0xFF374151),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF374151)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  "New Chat",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE27B4F),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search chats...",
                hintStyle: GoogleFonts.poppins(color: const Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final chat = _chatHistory[index];
                return ListTile(
                  title: Text(chat.title, style: GoogleFonts.poppins()),
                  subtitle: Text(chat.subtitle, style: GoogleFonts.poppins()),
                  trailing: chat.isHighlighted
                      ? const Icon(Icons.star, color: Colors.yellow)
                      : null,
                  onTap: () => Navigator.pop(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
