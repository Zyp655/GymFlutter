import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/openai_service.dart';
import '../../../domain/entities/chat_message.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final OpenAIService _openAIService;

  AiChatCubit({required OpenAIService openAIService})
    : _openAIService = openAIService,
      super(const AiChatLoaded(messages: []));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final currentMessages = _currentMessages;

    final userMessage = ChatMessage(
      role: ChatRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...currentMessages, userMessage];
    emit(AiChatLoaded(messages: updatedMessages, isTyping: true));

    try {
      final response = await _openAIService.chat(
        history: currentMessages,
        question: text.trim(),
      );

      final assistantMessage = ChatMessage(
        role: ChatRole.assistant,
        content: response,
        timestamp: DateTime.now(),
      );

      emit(AiChatLoaded(messages: [...updatedMessages, assistantMessage]));
    } catch (e) {
      emit(
        AiChatError(message: e.toString(), previousMessages: updatedMessages),
      );
    }
  }

  void retryAfterError() {
    final current = state;
    if (current is AiChatError) {
      emit(AiChatLoaded(messages: current.previousMessages));
    }
  }

  void clearChat() {
    emit(const AiChatLoaded(messages: []));
  }

  List<ChatMessage> get _currentMessages {
    final current = state;
    if (current is AiChatLoaded) return current.messages;
    if (current is AiChatError) return current.previousMessages;
    return [];
  }
}
