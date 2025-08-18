import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/healing_tree_model.dart';

class HealingTreeProvider with ChangeNotifier {
  HealingTreeModel? _healingTree;
  bool _isLoading = false;

  HealingTreeModel? get healingTree => _healingTree;
  bool get isLoading => _isLoading;

  HealingTreeProvider() {
    _loadHealingTree();
  }

  Future<void> _loadHealingTree() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final treeJson = prefs.getString('healing_tree');

      if (treeJson != null) {
        _healingTree = HealingTreeModel.fromMap(json.decode(treeJson));
      } else {
        // Create initial tree
        _healingTree = HealingTreeModel(
          userId: 'demo_user',
          state: TreeState.sprouting,
          level: 1,
          experience: 0,
          lastUpdated: DateTime.now(),
        );
        await _saveHealingTree();
      }

    } catch (e) {
      print('Error loading healing tree: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveHealingTree() async {
    if (_healingTree == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('healing_tree', json.encode(_healingTree!.toMap()));
    } catch (e) {
      print('Error saving healing tree: $e');
    }
  }

  Future<void> updateTreeProgress({
    required String eventType,
    int experienceGain = 10,
  }) async {
    if (_healingTree == null) return;

    int newExperience = _healingTree!.experience + experienceGain;
    int newLevel = _healingTree!.level;
    TreeState newState = _healingTree!.state;

    // Level up logic
    while (newExperience >= _getExperienceForNextLevel(newLevel)) {
      newExperience -= _getExperienceForNextLevel(newLevel);
      newLevel++;
    }

    // Update tree state based on level and recent activity
    newState = _calculateTreeState(newLevel, eventType);

    _healingTree = _healingTree!.copyWith(
      level: newLevel,
      experience: newExperience,
      state: newState,
    );

    await _saveHealingTree();
    notifyListeners();
  }

  TreeState _calculateTreeState(int level, String eventType) {
    if (level >= 10) return TreeState.flourishing;
    if (level >= 7) return TreeState.blooming;
    if (level >= 4) return TreeState.growing;
    if (level >= 2) return TreeState.sprouting;
    return TreeState.sprouting;
  }

  int _getExperienceForNextLevel(int currentLevel) {
    return 50 + (currentLevel * 25); // Progressive experience requirements
  }

  Future<void> updateFromStoryEnding(String storyMoodEffect) async {
    int experienceGain = 20;

    switch (storyMoodEffect) {
      case 'hopeful':
      case 'inspired':
      case 'empowered':
        experienceGain = 30;
        break;
      case 'wise':
      case 'enlightened':
      case 'awakened':
        experienceGain = 25;
        break;
      case 'peaceful':
      case 'serene':
      case 'tranquil':
        experienceGain = 20;
        break;
      default:
        experienceGain = 15;
    }

    await updateTreeProgress(
      eventType: 'story_completion',
      experienceGain: experienceGain,
    );
  }

  Future<void> updateFromQuestCompletion() async {
    await updateTreeProgress(
      eventType: 'quest_completion',
      experienceGain: 15,
    );
  }

  Future<void> updateFromMoodImprovement(int moodLevel) async {
    int experienceGain = moodLevel >= 7 ? 10 : 5;
    await updateTreeProgress(
      eventType: 'mood_improvement',
      experienceGain: experienceGain,
    );
  }

  double get progressToNextLevel {
    if (_healingTree == null) return 0.0;
    final nextLevelExp = _getExperienceForNextLevel(_healingTree!.level);
    return _healingTree!.experience / nextLevelExp;
  }

  String getTreeImagePath() {
    if (_healingTree == null) return 'assets/images/tree_sprouting.png';

    switch (_healingTree!.state) {
      case TreeState.withered:
        return 'assets/images/tree_withered.png';
      case TreeState.sprouting:
        return 'assets/images/tree_sprouting.png';
      case TreeState.growing:
        return 'assets/images/tree_growing.png';
      case TreeState.blooming:
        return 'assets/images/tree_blooming.png';
      case TreeState.flourishing:
        return 'assets/images/tree_flourishing.png';
    }
  }
}