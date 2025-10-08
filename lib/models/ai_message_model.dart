class AiMessage {
  final String id;
  final bool isUser;
  final String content;
  final DateTime timestamp;
  final String moodTag;

  AiMessage({
    required this.id,
    required this.isUser,
    required this.content,
    required this.timestamp,
    this.moodTag = 'neutral',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isUser': isUser,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'moodTag': moodTag,
    };
  }

  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      id: map['id'] ?? '',
      isUser: map['isUser'] ?? false,
      content: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      moodTag: map['moodTag'] ?? 'neutral',
    );
  }
}
