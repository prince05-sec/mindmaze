class JournalEntry {
  final String id;
  final DateTime date;
  final String mood;
  final String entry;
  final List<String> tags;
  final bool isVoice;
  final String? transcript;
  final String tone;

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.entry,
    this.tags = const [],
    this.isVoice = false,
    this.transcript,
    this.tone = 'neutral',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'entry': entry,
      'tags': tags,
      'isVoice': isVoice,
      'transcript': transcript,
      'tone': tone,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      mood: map['mood'] ?? 'neutral',
      entry: map['entry'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      isVoice: map['isVoice'] ?? false,
      transcript: map['transcript'],
      tone: map['tone'] ?? 'neutral',
    );
  }
}
