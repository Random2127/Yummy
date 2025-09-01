import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Singleton instance to make call to API
  final Gemini _gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(uid: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(
    uid: "1",
    firstName: "Gemini",
    avatar: "assets/images/google-gemini-icon-logo-png_seeklogo-623016.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUI());
  }

  Widget _buildUI() {
    return DashChat(
      messages: messages,
      user: currentUser,
      onSend: _sendMessage,
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    final messageText = chatMessage.text ?? '';
    final response = await _gemini.prompt(parts: [Part.text(messageText)]);

    final replyText = response?.output ?? '';

    final reply = ChatMessage(
      text: replyText,
      user: geminiUser,
      createdAt: DateTime.now(),
      customProperties: {'isJson': _isJson(replyText)},
    );

    setState(() {
      messages = [chatMessage, ...messages];
    });
  }

  bool _isJson(String replyText) {
    try {
      jsonDecode(replyText);
      return true;
    } catch (_) {
      return false;
    }
  }
}
