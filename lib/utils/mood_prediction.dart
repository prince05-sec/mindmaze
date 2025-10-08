import 'dart:math';

import '../models/mood_model.dart';

class MoodInsight {
  final double average;
  final double trend; // positive means improvement
  final String summary;

  const MoodInsight({
    required this.average,
    required this.trend,
    required this.summary,
  });
}

class MoodPrediction {
  static MoodInsight analyze(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return const MoodInsight(
        average: 5,
        trend: 0,
        summary: 'No mood check-ins yet. Start logging to see insights.',
      );
    }

    final ordered = [...moods]..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final average = ordered.fold<double>(0, (sum, mood) => sum + mood.moodLevel) /
        ordered.length;

    final trend = _movingAverageTrend(ordered);

    String summary;
    if (trend > 0.5) {
      summary = 'Your calm days are increasing by ${(trend * 10).round()}% this week.';
    } else if (trend < -0.5) {
      summary = 'Mood dips detected. Consider a grounding ritual today.';
    } else {
      summary = 'Mood is steady. Keep nurturing your daily rituals.';
    }

    return MoodInsight(
      average: average,
      trend: trend,
      summary: summary,
    );
  }

  static double _movingAverageTrend(List<MoodModel> moods) {
    if (moods.length < 3) return 0;

    final window = min(5, moods.length);
    final recent = moods.sublist(moods.length - window);

    double weightedSum = 0;
    double weightTotal = 0;
    for (int i = 0; i < recent.length; i++) {
      final weight = (i + 1).toDouble();
      weightedSum += recent[i].moodLevel * weight;
      weightTotal += weight;
    }

    final weightedAverage = weightedSum / weightTotal;
    final baseline = recent.first.moodLevel.toDouble();
    return ((weightedAverage - baseline) / 10).clamp(-1.0, 1.0);
  }
}
