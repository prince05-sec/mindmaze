import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/mood_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/mood_chart_widget.dart';

class MoodChartScreen extends StatelessWidget {
  const MoodChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Trends'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFE6F3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<MoodProvider>(
          builder: (context, moodProvider, child) {
            final insight = moodProvider.latestInsight;
            final moods = moodProvider.moodHistory;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (insight != null) _buildInsightCard(insight.summary),
                  const SizedBox(height: 20),
                  MoodChartWidget(moods: moods),
                  const SizedBox(height: 24),
                  _buildStatsRow(moodProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInsightCard(String summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9DCEFF), Color(0xFFFFB4A2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Weekly Insight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(MoodProvider provider) {
    return Row(
      children: [
        _buildStatCard('7-day Avg', provider.getAverageMood(7).toStringAsFixed(1)),
        const SizedBox(width: 16),
        _buildStatCard('30-day Avg', provider.getAverageMood(30).toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
