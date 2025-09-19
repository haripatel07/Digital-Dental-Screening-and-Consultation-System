import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  static const routeName = '/chatbot';
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  final List<String> quickSuggestions = [
    "How to prevent cavities?",
    "What causes gum disease?",
    "How do I whiten teeth?",
    "What to do for toothache?",
  ];

  Future<void> sendMessage(String message) async {
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });
    try {
      final response = await _apiService.sendChatMessage(message);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response.reply, isUser: false));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages
            .add(ChatMessage(text: "Error: ${e.toString()}", isUser: false));
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessage(ChatMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: quickSuggestions.map((q) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(q, style: const TextStyle(fontSize: 13)),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              onPressed: () => sendMessage(q),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dental Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1),
          _buildQuickSuggestions(),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          sendMessage(value);
                          _controller.clear();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Ask me about dental health...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
