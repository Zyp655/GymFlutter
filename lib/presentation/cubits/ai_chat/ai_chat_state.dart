import 'package:equatable/equatable.dart';

import '../../../domain/entities/chat_message.dart';

abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {
  const AiChatInitial();
}

class AiChatLoaded extends AiChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  const AiChatLoaded({required this.messages, this.isTyping = false});

  AiChatLoaded copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return AiChatLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping];
}

class AiChatError extends AiChatState {
  final String message;
  final List<ChatMessage> previousMessages;

  const AiChatError({required this.message, this.previousMessages = const []});

  @override
  List<Object?> get props => [message, previousMessages];
}
