class Quest {
  final String id;
  final String title;
  final String description;
  final String category;
  final int difficultyLevel;
  final int estimatedMinutes;
  final List<String> tags;
  final String icon;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficultyLevel = 1,
    this.estimatedMinutes = 5,
    this.tags = const [],
    this.icon = '🎯',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficultyLevel': difficultyLevel,
      'estimatedMinutes': estimatedMinutes,
      'tags': tags,
      'icon': icon,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      difficultyLevel: map['difficultyLevel'] ?? 1,
      estimatedMinutes: map['estimatedMinutes'] ?? 5,
      tags: List<String>.from(map['tags'] ?? []),
      icon: map['icon'] ?? '🎯',
    );
  }
}

class UserQuest {
  final String id;
  final String userId;
  final Quest quest;
  final DateTime assignedAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final String? notes;

  UserQuest({
    required this.id,
    required this.userId,
    required this.quest,
    required this.assignedAt,
    this.completedAt,
    this.isCompleted = false,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'quest': quest.toMap(),
      'assignedAt': assignedAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory UserQuest.fromMap(Map<String, dynamic> map) {
    return UserQuest(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      quest: Quest.fromMap(map['quest']),
      assignedAt: DateTime.fromMillisecondsSinceEpoch(map['assignedAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      isCompleted: map['isCompleted'] ?? false,
      notes: map['notes'],
    );
  }

  UserQuest copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
  }) {
    return UserQuest(
      id: id,
      userId: userId,
      quest: quest,
      assignedAt: assignedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}