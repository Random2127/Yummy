import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:yummy/consts.dart';
import 'package:yummy/widgets/recipe_card.dart';

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

      messageOptions: MessageOptions(
        showTime: true,
        borderRadius: 12,
        showCurrentUserAvatar: true,
        messageTextBuilder:
            (
              ChatMessage msg,
              ChatMessage? previousMessage,
              ChatMessage? nextMessage,
            ) {
              final isGemini = msg.user.id == geminiUser.id;
              final data = msg.customProperties;

              if (isGemini && data != null && data is Map<String, dynamic>) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: RecipeCard(json: jsonEncode(data)),
                );
              }
              return Text(msg.text ?? '');
            },
      ),
    );
  }

  void onSend(ChatMessage message) async {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: message.text, // wrap with the prompt
          user: currentUser,
          createdAt: DateTime.now(),
        ),
      );
    });

    try {
      final response = await _gemini.prompt(
        parts: [
          Part.text(
            'Return only raw JSON with this structure: '
            '{"title": "...", "description": "...", "time": 30, "servings": 2, '
            '"cuisine": "...", "ingredients": ["..."], "instructions": ["..."]}. '
            'User request: ${message.text}',
          ),
        ],
      );
      final reply = response?.output ?? '';
      String cleaned = reply
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      Map<String, dynamic>? recipeData = jsonDecode(cleaned);

      setState(() {
        messages.insert(
          0,
          ChatMessage(
            customProperties: recipeData, // data comes here
            user: geminiUser,
            createdAt: DateTime.now(),
            isMarkdown: false,
          ),
        );
      });
    } catch (e) {
      print('Error from Gemini: $e');
    }
  }
}
