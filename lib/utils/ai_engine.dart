import 'dart:math';

import 'data_constants.dart';

class AiAnalysisResult {
  final String moodTag;
  final String response;
  final String followUp;
  final double confidence;

  const AiAnalysisResult({
    required this.moodTag,
    required this.response,
    required this.followUp,
    required this.confidence,
  });
}

class QuestSuggestion {
  final String title;
  final String description;
  final String moodTag;

  const QuestSuggestion({
    required this.title,
    required this.description,
    required this.moodTag,
  });
}

class AiEngine {
  static final Random _random = Random();

  static AiAnalysisResult analyzeInput(String input) {
    final lower = input.toLowerCase();
    String detectedMood = 'neutral';
    double bestScore = 0;

    DataConstants.emotionKeywords.forEach((mood, keywords) {
      final score = keywords.fold<double>(0, (acc, word) {
        if (lower.contains(word)) {
          return acc + 1;
        }
        return acc;
      });
      if (score > bestScore) {
        bestScore = score;
        detectedMood = mood;
      }
    });

    final response = DataConstants.aiResponses[detectedMood] ??
        DataConstants.aiResponses['neutral']!;
    final followUps = DataConstants.followUpQuestions[detectedMood] ??
        DataConstants.followUpQuestions['neutral']!;

    return AiAnalysisResult(
      moodTag: detectedMood,
      response: response,
      followUp: followUps[_random.nextInt(followUps.length)],
      confidence: bestScore > 0 ? (bestScore / 3).clamp(0.2, 0.75) : 0.25,
    );
  }

  static QuestSuggestion generateQuest(String moodTag) {
    final suggestion = DataConstants.questSuggestions[moodTag] ??
        DataConstants.questSuggestions['neutral']!;
    return QuestSuggestion(
      title: 'Daily Quest',
      description: suggestion,
      moodTag: moodTag,
    );
  }

  static String analyzeTone(String transcript) {
    try {
      final result = analyzeInput(transcript);
      if (result.confidence >= 0.6) {
        return result.moodTag;
      }
      return 'neutral';
    } catch (e) {
      // Fallback to neutral if analysis fails
      return 'neutral';
    }
  }

  static String getAffirmation(String moodTag) {
    switch (moodTag) {
      case 'sad':
        return 'You deserve tenderness. Place a hand over your heart and breathe slowly.';
      case 'anxious':
        return 'Your breath is an anchor. Inhale for four, hold for four, exhale for six.';
      case 'angry':
        return 'Let the tension exit slowly. Notice one thing that feels steady right now.';
      case 'calm':
        return 'Honor this calm. Store it inside a memory jar for your future self.';
      case 'happy':
        return 'Your joy is a beacon. May it ripple gently to someone who needs light.';
      default:
        return 'One mindful breath can reset the rhythm of your day.';
    }
  }
}
