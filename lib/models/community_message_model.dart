class CommunityMessage {
  final String id;
  final String userId;
  final String message;
  final DateTime timestamp;
  final bool isAnonymous;
  final Map<String, int> reactions;
  final List<String> tags;

  CommunityMessage({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    this.isAnonymous = true,
    this.reactions = const {
      '💚': 0,
      '🤍': 0,
      '😌': 0,
    },
    this.tags = const [],
  });

  CommunityMessage copyWith({
    Map<String, int>? reactions,
    List<String>? tags,
  }) {
    return CommunityMessage(
      id: id,
      userId: userId,
      message: message,
      timestamp: timestamp,
      isAnonymous: isAnonymous,
      reactions: reactions ?? this.reactions,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isAnonymous': isAnonymous,
      'reactions': reactions,
      'tags': tags,
    };
  }

  factory CommunityMessage.fromMap(Map<String, dynamic> map) {
    return CommunityMessage(
      id: map['id'],
      userId: map['userId'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      isAnonymous: map['isAnonymous'] ?? true,
      reactions: Map<String, int>.from(map['reactions'] ?? {
        '💚': 0,
        '🤍': 0,
        '😌': 0,
      }),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
