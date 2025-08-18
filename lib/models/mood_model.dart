class MoodModel {
  final String id;
  final String userId;
  final int moodLevel; // 0-10
  final String emoji;
  final String? journalEntry;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  MoodModel({
    required this.id,
    required this.userId,
    required this.moodLevel,
    required this.emoji,
    this.journalEntry,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'moodLevel': moodLevel,
      'emoji': emoji,
      'journalEntry': journalEntry,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'metadata': metadata,
    };
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      moodLevel: map['moodLevel'] ?? 5,
      emoji: map['emoji'] ?? '😐',
      journalEntry: map['journalEntry'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      metadata: map['metadata'],
    );
  }

  String get moodDescription {
    switch (moodLevel) {
      case 0:
      case 1:
        return 'Very Low';
      case 2:
      case 3:
        return 'Low';
      case 4:
      case 5:
        return 'Neutral';
      case 6:
      case 7:
        return 'Good';
      case 8:
      case 9:
        return 'Great';
      case 10:
        return 'Amazing';
      default:
        return 'Neutral';
    }
  }
}