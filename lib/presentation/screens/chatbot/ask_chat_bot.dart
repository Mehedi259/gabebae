//lib/presentation/screens/chatbot/ask_chat_bot.dart
import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../presentation/widgets/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/chat_controller.dart';
import '../../../global/model/chat_model.dart';

/// =======================================
/// Main Chat Screen with API Integration
/// =======================================
class MenuSidekickChatScreen extends StatefulWidget {
  const MenuSidekickChatScreen({super.key});

  @override
  State<MenuSidekickChatScreen> createState() => _MenuSidekickChatScreenState();
}

class _MenuSidekickChatScreenState extends State<MenuSidekickChatScreen> {
  final ChatController _chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 2;

  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _chatController.createNewConversation();
  }

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
      // Already on chat screen
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _chatController.messageController.text = "[Image: ${image.name}]";
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _chatController.messageController.text = "[File: ${result.files.first.name}]";
      });
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (val) {
          setState(() {
            _chatController.messageController.text = val.recognizedWords;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

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
              l10n.menuSidekickAI,
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

      /// BODY
      body: SafeArea(
        child: Obx(() {
          if (_chatController.isLoadingConversation.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_chatController.hasActiveConversation) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No active conversation',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _initializeChat,
                    child: const Text('Start New Chat'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              /// Messages
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._chatController.messages.map((msg) => _buildMessageBubble(msg)),

                      // Show loading indicator when sending
                      if (_chatController.isSendingMessage.value)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(width: 16),
                              Text('AI is thinking...', style: GoogleFonts.poppins(color: Colors.grey)),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// MESSAGE INPUT
              _buildMessageInput(),
            ],
          );
        }),
      ),

      /// Custom Navigation
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
                    message.content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isUser ? Colors.white : const Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.createdAt),
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

  Widget _buildMessageInput() {
    final l10n = AppLocalizations.of(context)!;

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
                border: Border.all(color: const Color(0xFF669A59), width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _chatController.messageController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n.askAnything,
                  hintStyle: GoogleFonts.poppins(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon:
                    const Icon(Icons.attach_file, color: Color(0xFF6B7280)),
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

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final success = await _chatController.sendMessage(text);
    if (success) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
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
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.deleteThisChat, style: GoogleFonts.poppins()),
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
    final l10n = AppLocalizations.of(context)!;
    final conversationId = _chatController.currentConversation.value?.id;

    if (conversationId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteThisChat,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(l10n.deleteChatConfirm, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _chatController.deleteConversation(conversationId);
              if (success && mounted) {
                // Go back to home or create new conversation
                _initializeChat();
              }
            },
            child: Text(l10n.delete,
                style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChatHistoryDrawer(BuildContext context) {
    // Load history first
    _chatController.loadChatHistory();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatHistoryScreen(chatController: _chatController),
      ),
    );
  }
}

/// =======================================
/// Chat History Screen with API
/// =======================================
class ChatHistoryScreen extends StatefulWidget {
  final ChatController chatController;

  const ChatHistoryScreen({super.key, required this.chatController});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.menuSidekick,
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
      body: Obx(() {
        if (widget.chatController.isLoadingHistory.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await widget.chatController.createNewConversation();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    l10n.newChat,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchChats,
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
              const SizedBox(height: 16),

              // ✅ API থেকে আসা conversation history
              if (widget.chatController.conversationHistory.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No chat history yet',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                )
              else
                ...widget.chatController.conversationHistory.map((conversation) {
                  return ListTile(
                    subtitle: Text(conversation.lastMessagePreview,
                        style: GoogleFonts.poppins()),
                    trailing: Text(
                      _formatDate(conversation.updatedAt),
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      widget.chatController.loadConversation(conversation);
                      Navigator.pop(context);
                    },
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}