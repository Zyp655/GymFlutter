enum ChatRole { user, assistant, system }

class ChatMessage {
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, String> toApiMap() => {'role': role.name, 'content': content};
}
