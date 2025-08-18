import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/mood_model.dart';

class MoodProvider with ChangeNotifier {
  List<MoodModel> _moodHistory = [];
  MoodModel? _currentMood;
  bool _isLoading = false;

  List<MoodModel> get moodHistory => _moodHistory;
  MoodModel? get currentMood => _currentMood;
  bool get isLoading => _isLoading;

  final List<String> _availableEmojis = [
    '😢', '😟', '😔', '😐', '🙂', '😊', '😄', '🤗', '😍', '🥰', '😇'
  ];

  List<String> get availableEmojis => _availableEmojis;

  MoodProvider() {
    _loadMoodHistory();
  }

  Future<void> saveMood({
    required String userId,
    required int moodLevel,
    required String emoji,
    String? journalEntry,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final mood = MoodModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        moodLevel: moodLevel,
        emoji: emoji,
        journalEntry: journalEntry,
        timestamp: DateTime.now(),
      );

      _currentMood = mood;
      _moodHistory.insert(0, mood);

      await _saveMoodToStorage();

    } catch (e) {
      print('Error saving mood: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMoodHistory() async {
    try {
      _isLoading = true;

      final prefs = await SharedPreferences.getInstance();
      final moodHistoryJson = prefs.getStringList('mood_history') ?? [];

      _moodHistory = moodHistoryJson
          .map((jsonStr) => MoodModel.fromMap(json.decode(jsonStr)))
          .toList();

      if (_moodHistory.isNotEmpty) {
        _currentMood = _moodHistory.first;
      }

      // Add some demo data if empty
      if (_moodHistory.isEmpty) {
        await _addDemoMoodData();
      }

    } catch (e) {
      print('Error loading mood history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveMoodToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moodHistoryJson = _moodHistory
          .take(30) // Keep only last 30 entries
          .map((mood) => json.encode(mood.toMap()))
          .toList();

      await prefs.setStringList('mood_history', moodHistoryJson);
    } catch (e) {
      print('Error saving mood to storage: $e');
    }
  }

  Future<void> _addDemoMoodData() async {
    final now = DateTime.now();
    final demoMoods = [
      MoodModel(
        id: '1',
        userId: 'demo_user',
        moodLevel: 7,
        emoji: '😊',
        journalEntry: 'Had a productive day at work',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      MoodModel(
        id: '2',
        userId: 'demo_user',
        moodLevel: 5,
        emoji: '😐',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      MoodModel(
        id: '3',
        userId: 'demo_user',
        moodLevel: 8,
        emoji: '😄',
        journalEntry: 'Great morning walk in the park',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
    ];

    _moodHistory.addAll(demoMoods);
    if (_moodHistory.isNotEmpty) {
      _currentMood = _moodHistory.first;
    }

    await _saveMoodToStorage();
  }

  List<MoodModel> getMoodsByDateRange(DateTime start, DateTime end) {
    return _moodHistory.where((mood) {
      return mood.timestamp.isAfter(start) && mood.timestamp.isBefore(end);
    }).toList();
  }

  double getAverageMood(int days) {
    if (_moodHistory.isEmpty) return 5.0;

    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recentMoods = _moodHistory.where((mood) => mood.timestamp.isAfter(cutoff));

    if (recentMoods.isEmpty) return 5.0;

    final sum = recentMoods.fold(0, (sum, mood) => sum + mood.moodLevel);
    return sum / recentMoods.length;
  }
}