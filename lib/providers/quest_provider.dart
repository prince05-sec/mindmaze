import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';
import '../models/quest_model.dart';

class QuestProvider with ChangeNotifier {
  List<UserQuest> _activeQuests = [];
  List<UserQuest> _completedQuests = [];
  bool _isLoading = false;
  final Uuid _uuid = const Uuid();

  List<UserQuest> get activeQuests => _activeQuests;
  List<UserQuest> get completedQuests => _completedQuests;
  bool get isLoading => _isLoading;
  int get totalCompletedQuests => _completedQuests.length;

  final List<Quest> _availableQuests = [
    Quest(
      id: 'gratitude_1',
      title: 'Gratitude Moment',
      description: 'Write down three things you\'re grateful for today',
      category: 'Mindfulness',
      estimatedMinutes: 5,
      icon: '🙏',
      tags: ['gratitude', 'reflection'],
    ),
    Quest(
      id: 'walk_1',
      title: 'Mindful Walk',
      description: 'Take a 10-minute walk and focus on your breathing',
      category: 'Movement',
      estimatedMinutes: 10,
      icon: '🚶‍♀️',
      tags: ['movement', 'mindfulness'],
    ),
    Quest(
      id: 'breathing_1',
      title: 'Deep Breathing',
      description: 'Practice 4-7-8 breathing technique for 5 minutes',
      category: 'Breathing',
      estimatedMinutes: 5,
      icon: '🫁',
      tags: ['breathing', 'relaxation'],
    ),
    Quest(
      id: 'kindness_1',
      title: 'Random Act of Kindness',
      description: 'Do something kind for someone today',
      category: 'Social',
      estimatedMinutes: 15,
      icon: '💝',
      tags: ['kindness', 'social'],
    ),
    Quest(
      id: 'nature_1',
      title: 'Nature Connection',
      description: 'Spend 10 minutes observing nature',
      category: 'Nature',
      estimatedMinutes: 10,
      icon: '🌿',
      tags: ['nature', 'observation'],
    ),
    Quest(
      id: 'meditation_1',
      title: 'Mini Meditation',
      description: 'Meditate for 5 minutes using your breath as an anchor',
      category: 'Meditation',
      estimatedMinutes: 5,
      icon: '🧘‍♀️',
      tags: ['meditation', 'mindfulness'],
    ),
    Quest(
      id: 'hydration_1',
      title: 'Hydration Check',
      description: 'Drink a full glass of water mindfully',
      category: 'Self-Care',
      estimatedMinutes: 2,
      icon: '💧',
      tags: ['health', 'self-care'],
    ),
    Quest(
      id: 'stretch_1',
      title: 'Gentle Stretch',
      description: 'Do 5 minutes of gentle stretching',
      category: 'Movement',
      estimatedMinutes: 5,
      icon: '🤸‍♀️',
      tags: ['movement', 'body'],
    ),
  ];

  QuestProvider() {
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      // Load active quests
      final activeQuestsJson = prefs.getStringList('active_quests') ?? [];
      _activeQuests = activeQuestsJson
          .map((jsonStr) => UserQuest.fromMap(json.decode(jsonStr)))
          .toList();

      // Load completed quests
      final completedQuestsJson = prefs.getStringList('completed_quests') ?? [];
      _completedQuests = completedQuestsJson
          .map((jsonStr) => UserQuest.fromMap(json.decode(jsonStr)))
          .toList();

      // Generate initial quests if none exist
      if (_activeQuests.isEmpty && _completedQuests.isEmpty) {
        await _generateInitialQuests();
      }
    } catch (e) {
      print('Error loading quests: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _generateInitialQuests() async {
    // Removed unused variable 'random'
    final selectedQuests = _availableQuests.take(3).toList();

    for (int i = 0; i < selectedQuests.length; i++) {
      final userQuest = UserQuest(
        id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
        userId: 'demo_user',
        quest: selectedQuests[i],
        assignedAt: DateTime.now(),
      );
      _activeQuests.add(userQuest);
    }

    await _saveQuests();
  }

  Future<void> assignQuestsBasedOnMood(int moodLevel, String? storyPath) async {
    final random = Random();
    List<Quest> suitableQuests = [];

    // Select quests based on mood
    if (moodLevel <= 3) {
      // Low mood - gentle, self-care quests
      suitableQuests = _availableQuests
          .where((quest) =>
              quest.category == 'Self-Care' ||
              quest.category == 'Breathing' ||
              quest.tags.contains('relaxation'))
          .toList();
    } else if (moodLevel <= 6) {
      // Neutral mood - mindfulness and reflection
      suitableQuests = _availableQuests
          .where((quest) =>
              quest.category == 'Mindfulness' || quest.category == 'Meditation')
          .toList();
    } else {
      // Good mood - active and social quests
      suitableQuests = _availableQuests
          .where((quest) =>
              quest.category == 'Movement' ||
              quest.category == 'Social' ||
              quest.category == 'Nature')
          .toList();
    }

    // Ensure we have enough quests
    if (suitableQuests.length < 2) {
      suitableQuests = _availableQuests;
    }

    // Remove already active quests
    final activeQuestIds = _activeQuests.map((uq) => uq.quest.id).toSet();
    suitableQuests =
        suitableQuests.where((q) => !activeQuestIds.contains(q.id)).toList();

    // Add 2-3 new quests
    final questsToAdd = (suitableQuests..shuffle(random)).take(2).toList();

    for (final quest in questsToAdd) {
      final userQuest = UserQuest(
        id: DateTime.now().millisecondsSinceEpoch.toString() + quest.id,
        userId: 'demo_user',
        quest: quest,
        assignedAt: DateTime.now(),
      );
      _activeQuests.add(userQuest);
    }

    await _saveQuests();
    notifyListeners();
  }

  Future<void> completeQuest(String questId, {String? notes}) async {
    final questIndex = _activeQuests.indexWhere((q) => q.id == questId);
    if (questIndex == -1) return;

    final quest = _activeQuests[questIndex];
    final completedQuest = quest.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      notes: notes,
    );

    _activeQuests.removeAt(questIndex);
    _completedQuests.insert(0, completedQuest);

    await _saveQuests();
    notifyListeners();
  }

  Future<void> _saveQuests() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final activeQuestsJson =
          _activeQuests.map((quest) => json.encode(quest.toMap())).toList();
      await prefs.setStringList('active_quests', activeQuestsJson);

      final completedQuestsJson = _completedQuests
          .take(50) // Keep only last 50 completed quests
          .map((quest) => json.encode(quest.toMap()))
          .toList();
      await prefs.setStringList('completed_quests', completedQuestsJson);
    } catch (e) {
      print('Error saving quests: $e');
    }
  }

  Future<void> addCustomQuest(String moodTag, String description) async {
    final quest = Quest(
      id: 'ai_${_uuid.v4()}',
      title: 'Daily Quest',
      description: description,
      category: _mapMoodToCategory(moodTag),
      estimatedMinutes: 5,
      icon: _mapMoodToIcon(moodTag),
      tags: [moodTag, 'ai'],
    );

    final userQuest = UserQuest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'local_user',
      quest: quest,
      assignedAt: DateTime.now(),
    );

    _activeQuests.insert(0, userQuest);
    await _saveQuests();
    notifyListeners();
  }

  String _mapMoodToCategory(String moodTag) {
    switch (moodTag) {
      case 'sad':
        return 'Gratitude';
      case 'anxious':
        return 'Grounding';
      case 'angry':
        return 'Release';
      case 'happy':
        return 'Kindness';
      case 'calm':
        return 'Mindfulness';
      default:
        return 'Reflection';
    }
  }

  String _mapMoodToIcon(String moodTag) {
    switch (moodTag) {
      case 'sad':
        return '💧';
      case 'anxious':
        return '🌀';
      case 'angry':
        return '🔥';
      case 'happy':
        return '🌞';
      case 'calm':
        return '🌿';
      default:
        return '✨';
    }
  }

  List<UserQuest> getQuestsByCategory(String category) {
    return _activeQuests
        .where((quest) => quest.quest.category == category)
        .toList();
  }

  int getCompletedQuestsInLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _completedQuests
        .where((quest) =>
            quest.completedAt != null && quest.completedAt!.isAfter(cutoff))
        .length;
  }
}
