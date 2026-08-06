import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_message.dart';
import '../data/ecobot_repository.dart';
import '../data/ecobot_responses.dart';

final ecobotRepositoryProvider = Provider<EcobotRepository>((ref) => EcobotRepository());

final botTypingProvider = StateProvider<bool>((ref) => false);

class BotNotifier extends StateNotifier<List<ChatMessage>> {
  BotNotifier(this._repository)
      : super([
          ChatMessage(
            text: EcobotData.welcomeMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ]);

  final EcobotRepository _repository;

  void Function(bool)? onTypingChanged;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text.trim(), isUser: true, timestamp: DateTime.now());
    final historyBeforeReply = [...state, userMessage];
    state = historyBeforeReply;

    onTypingChanged?.call(true);

    String replyText;
    try {
      replyText = await _repository.sendMessage(text.trim(), state);
    } catch (_) {
      // Fallback a respuestas predefinidas si la Appwrite Function falla
      // (sin conexión, function caída, cuota agotada, etc.)
      replyText = EcobotData.getReply(text);
    }

    onTypingChanged?.call(false);

    final botMessage = ChatMessage(text: replyText, isUser: false, timestamp: DateTime.now());
    state = [...state, botMessage];
  }
}

final botProvider = StateNotifierProvider<BotNotifier, List<ChatMessage>>(
  (ref) {
    final notifier = BotNotifier(ref.watch(ecobotRepositoryProvider));
    notifier.onTypingChanged = (value) => ref.read(botTypingProvider.notifier).state = value;
    return notifier;
  },
);