import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_message.dart';
import '../data/ecobot_responses.dart';

class BotNotifier extends StateNotifier<List<ChatMessage>> {
  BotNotifier()
      : super([
          ChatMessage(
            text: EcobotData.welcomeMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ]);

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    final botReply = ChatMessage(
      text: EcobotData.getReply(text),
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage, botReply];
  }
}

final botProvider = StateNotifierProvider<BotNotifier, List<ChatMessage>>(
  (ref) => BotNotifier(),
);