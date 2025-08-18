class StoryScene {
  final String id;
  final String text;
  final List<StoryChoice> choices;
  final String moodEffect;
  final Map<String, dynamic>? metadata;

  StoryScene({
    required this.id,
    required this.text,
    required this.choices,
    required this.moodEffect,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'choices': choices.map((choice) => choice.toMap()).toList(),
      'moodEffect': moodEffect,
      'metadata': metadata,
    };
  }

  factory StoryScene.fromMap(Map<String, dynamic> map) {
    return StoryScene(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      choices: List<StoryChoice>.from(
        map['choices']?.map((choice) => StoryChoice.fromMap(choice)) ?? [],
      ),
      moodEffect: map['moodEffect'] ?? 'neutral',
      metadata: map['metadata'],
    );
  }
}

class StoryChoice {
  final String label;
  final String nextSceneId;
  final Map<String, dynamic>? effects;

  StoryChoice({
    required this.label,
    required this.nextSceneId,
    this.effects,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'nextSceneId': nextSceneId,
      'effects': effects,
    };
  }

  factory StoryChoice.fromMap(Map<String, dynamic> map) {
    return StoryChoice(
      label: map['label'] ?? '',
      nextSceneId: map['nextSceneId'] ?? '',
      effects: map['effects'],
    );
  }
}

class UserStoryProgress {
  final String userId;
  final String storyId;
  final String currentSceneId;
  final List<String> visitedScenes;
  final List<String> choicesMade;
  final DateTime lastUpdated;
  final bool isCompleted;

  UserStoryProgress({
    required this.userId,
    required this.storyId,
    required this.currentSceneId,
    this.visitedScenes = const [],
    this.choicesMade = const [],
    required this.lastUpdated,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storyId': storyId,
      'currentSceneId': currentSceneId,
      'visitedScenes': visitedScenes,
      'choicesMade': choicesMade,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  factory UserStoryProgress.fromMap(Map<String, dynamic> map) {
    return UserStoryProgress(
      userId: map['userId'] ?? '',
      storyId: map['storyId'] ?? '',
      currentSceneId: map['currentSceneId'] ?? '',
      visitedScenes: List<String>.from(map['visitedScenes'] ?? []),
      choicesMade: List<String>.from(map['choicesMade'] ?? []),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  UserStoryProgress copyWith({
    String? currentSceneId,
    List<String>? visitedScenes,
    List<String>? choicesMade,
    bool? isCompleted,
  }) {
    return UserStoryProgress(
      userId: userId,
      storyId: storyId,
      currentSceneId: currentSceneId ?? this.currentSceneId,
      visitedScenes: visitedScenes ?? this.visitedScenes,
      choicesMade: choicesMade ?? this.choicesMade,
      lastUpdated: DateTime.now(),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}