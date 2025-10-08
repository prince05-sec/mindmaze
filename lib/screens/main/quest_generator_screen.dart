import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/mood_provider.dart';
import '../../providers/quest_provider.dart';
import '../../utils/ai_engine.dart';
import '../../utils/app_theme.dart';

class QuestGeneratorScreen extends StatefulWidget {
  const QuestGeneratorScreen({super.key});

  @override
  State<QuestGeneratorScreen> createState() => _QuestGeneratorScreenState();
}

class _QuestGeneratorScreenState extends State<QuestGeneratorScreen> {
  QuestSuggestion? _suggestion;
  bool _isLoading = false;
  String? _selectedMoodTag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final moodProvider = context.read<MoodProvider>();
    final lastMood = moodProvider.currentMood;
    _selectedMoodTag ??= lastMood != null
        ? _mapEmojiToMood(lastMood.emoji)
        : 'calm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quest Generator'),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoodSelector(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateQuest,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? 'Generating...' : 'Generate Quest'),
              ),
              const SizedBox(height: 24),
              if (_suggestion != null) _buildSuggestionCard(_suggestion!),
              const Spacer(),
              if (_suggestion != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveQuest,
                    icon: const Icon(Icons.favorite_outline),
                    label: const Text('Accept Quest'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = const {
      'sad': 'Feeling tender or low',
      'anxious': 'Anxious or restless',
      'angry': 'Fiery or tense',
      'calm': 'Peaceful and centered',
      'happy': 'Bright and joyful',
      'neutral': 'Open to suggestions',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What mood should we nurture?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moods.entries.map((entry) {
            final isSelected = _selectedMoodTag == entry.key;
            return ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedMoodTag = entry.key),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(QuestSuggestion suggestion) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            suggestion.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            suggestion.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood focus: ${suggestion.moodTag.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.favorite_outline, color: AppTheme.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generateQuest() async {
    if (_selectedMoodTag == null) return;
    setState(() {
      _isLoading = true;
      _suggestion = null;
    });

    await Future.delayed(const Duration(milliseconds: 350));
    final suggestion = AiEngine.generateQuest(_selectedMoodTag!);

    setState(() {
      _suggestion = suggestion;
      _isLoading = false;
    });
  }

  Future<void> _saveQuest() async {
    if (_suggestion == null) return;
    await context
        .read<QuestProvider>()
        .addCustomQuest(_suggestion!.moodTag, _suggestion!.description);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quest added to your active list.')),
    );
  }

  String _mapEmojiToMood(String emoji) {
    if (['😢', '😟', '😔'].contains(emoji)) return 'sad';
    if (['🙂', '😊'].contains(emoji)) return 'calm';
    if (['😄', '🤗', '😍', '🥰', '😇'].contains(emoji)) return 'happy';
    if (['😐'].contains(emoji)) return 'neutral';
    return 'neutral';
  }
}
