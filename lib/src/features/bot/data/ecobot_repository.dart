import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../../../core/config/appwrite_config.dart';
import 'chat_message.dart';

class EcobotRepository {
  final Functions _functions = AppwriteClientService().functions;

  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    final execution = await _functions.createExecution(
      functionId: AppwriteConfig.ecobotFunctionId,
      body: jsonEncode({
        'message': message,
        'history': history
            .map((m) => {'text': m.text, 'isUser': m.isUser})
            .toList(),
      }),
    );

    if (execution.responseStatusCode >= 400) {
      throw Exception('Error del EcoBot: ${execution.responseBody}');
    }

    final data = jsonDecode(execution.responseBody) as Map<String, dynamic>;

    if (data['error'] != null) {
      throw Exception(data['error']);
    }

    return data['reply'] as String;
  }
}