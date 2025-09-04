import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini _gemini = Gemini.instance;
  final _currentUserId = 'user1';
  final _chatController = InMemoryChatController();
  String? _recipePrompt;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<User> resolveUser(UserID id) async {
    return User(id: id, name: id == _currentUserId ? 'You' : 'Gemini');
  }

  // Adding custom prompt
  Future<void> _loadPrompt() async {
    final prompt = await rootBundle.loadString('assets/prompt/recipe.txt');
    setState(() {
      _recipePrompt = prompt;
    });
  }

  void _onMessageSend(String text) {
    final userMsgId =
        'u-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}';
    final userMessage = TextMessage(
      id: userMsgId,
      authorId: _currentUserId,
      text: text,
      createdAt: DateTime.now().toUtc(),

      // gemini.generateFromText(fullPrompt);
    );

    // Will need to add prompt before message
    final fullPrompt = "${_recipePrompt ?? ''} $text";

    _chatController.insertMessage(userMessage);
    _sendToGemini(fullPrompt); // prompt
  }

  Future<void> _sendToGemini(String fullPrompt) async {
    final assistantId = 'g-${DateTime.now().millisecondsSinceEpoch}';
    final placeholder = TextMessage(
      id: assistantId,
      authorId: 'gemini',
      createdAt: DateTime.now().toUtc(),
      text: '',
    );

    _chatController.insertMessage(placeholder);

    try {
      final stream = _gemini.promptStream(parts: [Part.text(fullPrompt)]);
      var accumulated = '';

      // Listen to partial outputs and update the assistant message
      stream.listen(
        (event) {
          final chunk = event?.output ?? '';
          accumulated += chunk;

          final updated = TextMessage(
            id: assistantId,
            authorId: 'gemini',
            createdAt: placeholder.createdAt,
            text: accumulated,
          );

          // Update the existing message in the controller (UI will refresh)
          _chatController.updateMessage(placeholder, updated);
        },
        onError: (err) {
          final errorMsg = TextMessage(
            id: assistantId,
            authorId: 'gemini',
            createdAt: placeholder.createdAt,
            text: 'Error: $err',
          );
          _chatController.updateMessage(placeholder, errorMsg);
        },
      );
    } catch (e) {
      final err = TextMessage(
        id: assistantId,
        authorId: 'gemini',
        createdAt: DateTime.now().toUtc(),
        text: 'Failed to contact Gemini: $e',
      );
      _chatController.updateMessage(placeholder, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        currentUserId: _currentUserId,
        resolveUser: resolveUser,
        chatController: _chatController,
        onMessageSend: _onMessageSend,
      ),
    );
  }
}
