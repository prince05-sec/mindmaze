enum TreeState {
  withered,
  sprouting,
  growing,
  blooming,
  flourishing,
}

class HealingTreeModel {
  final String userId;
  final TreeState state;
  final int level;
  final int experience;
  final DateTime lastUpdated;
  final Map<String, dynamic>? customizations;

  HealingTreeModel({
    required this.userId,
    this.state = TreeState.sprouting,
    this.level = 1,
    this.experience = 0,
    required this.lastUpdated,
    this.customizations,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'state': state.index,
      'level': level,
      'experience': experience,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'customizations': customizations,
    };
  }

  factory HealingTreeModel.fromMap(Map<String, dynamic> map) {
    return HealingTreeModel(
      userId: map['userId'] ?? '',
      state: TreeState.values[map['state'] ?? 1],
      level: map['level'] ?? 1,
      experience: map['experience'] ?? 0,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
      customizations: map['customizations'],
    );
  }

  HealingTreeModel copyWith({
    TreeState? state,
    int? level,
    int? experience,
    Map<String, dynamic>? customizations,
  }) {
    return HealingTreeModel(
      userId: userId,
      state: state ?? this.state,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      lastUpdated: DateTime.now(),
      customizations: customizations ?? this.customizations,
    );
  }

  String get stateDescription {
    switch (state) {
      case TreeState.withered:
        return 'Take some time for self-care';
      case TreeState.sprouting:
        return 'Your journey begins';
      case TreeState.growing:
        return 'Growing stronger';
      case TreeState.blooming:
        return 'Flourishing beautifully';
      case TreeState.flourishing:
        return 'Thriving with wisdom';
    }
  }
}