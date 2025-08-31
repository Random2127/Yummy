import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://images.seeklogo.com/logo-png/62/1/google-gemini-icon-logo-png_seeklogo-623016.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUI());
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      final question = chatMessage.text;

      final response = await gemini.prompt(parts: [Part.text(question)]);

      String output = "";

      // grab the parts into a local non-nullable variable
      final parts = response?.content?.parts;
      if (parts != null && parts.isNotEmpty) {
        for (final part in parts) {
          // preferred safe extraction if the library exposes TextPart
          if (part is TextPart) {
            output += part.text;
          } else {
            // fallback: try to read a `text` field dynamically (wrapped in try/catch)
            try {
              final maybeText = (part as dynamic).text;
              if (maybeText is String) output += maybeText;
            } catch (_) {
              // non-text part — ignore
            }
          }
        }
      }

      final aiMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: output.isNotEmpty ? output : "No response",
      );

      setState(() {
        messages = [aiMessage, ...messages];
      });
    } catch (e, st) {
      // better error logging and show a message in the chat
      print("Gemini error: $e\n$st");
      final errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Error: ${e.toString()}",
      );
      setState(() {
        messages = [errorMessage, ...messages];
      });
    }
  }
}
