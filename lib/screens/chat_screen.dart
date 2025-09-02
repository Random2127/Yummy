import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini _gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
    profileImage: 'assets/images/IMG-20210404-WA0013.jpeg',
  );

  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'Gemini',
    profileImage:
        'assets/images/google-gemini-icon-logo-png_seeklogo-623016.png',
  );

  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return DashChat(
      currentUser: currentUser,
      onSend: onSend,
      messages: messages,
    );
  }

  void onSend(ChatMessage message) async {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: message.text,
          user: currentUser,
          createdAt: DateTime.now(),
        ),
      );
    });

    try {
      final response = await _gemini.prompt(parts: [Part.text(message.text)]);
      final reply = response?.output ?? '';

      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: reply,
            user: geminiUser,
            createdAt: DateTime.now(),
            isMarkdown: true,
          ),
        );
      });
    } catch (e) {
      print('Error from Gemini: $e');
    }
  }
}
