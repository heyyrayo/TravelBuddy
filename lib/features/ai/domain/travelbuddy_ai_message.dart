enum TravelBuddyAiMessageRole {
  user,
  assistant,
}

class TravelBuddyAiMessage {
  const TravelBuddyAiMessage({
    required this.role,
    required this.content,
    this.timestamp,
  });

  final TravelBuddyAiMessageRole role;
  final String content;
  final DateTime? timestamp;

  bool get isUser => role == TravelBuddyAiMessageRole.user;

  bool get isAssistant => role == TravelBuddyAiMessageRole.assistant;

  Map<String, dynamic> toApiJson() {
    return {
      'role': role == TravelBuddyAiMessageRole.user ? 'user' : 'assistant',
      'content': content,
    };
  }
}
