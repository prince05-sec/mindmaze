import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../providers/healing_tree_provider.dart';
import '../../utils/app_theme.dart';
import 'main_screen.dart';

class MoodInputScreen extends StatefulWidget {
  final bool isOnboarding;

  const MoodInputScreen({
    super.key,
    this.isOnboarding = false,
  });

  @override
  State<MoodInputScreen> createState() => _MoodInputScreenState();
}

class _MoodInputScreenState extends State<MoodInputScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMoodLevel = 5;
  String _selectedEmoji = '😐';
  final TextEditingController _journalController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? 'How are you feeling?' : 'Mood Check-in'),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Color(0xFFE6F3FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood Level Selector
                        const Text(
                          'How are you feeling right now?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rate your mood from 0 (very low) to 10 (amazing)',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Mood Slider with Animation
                        AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _selectedEmoji,
                                      style: const TextStyle(fontSize: 80),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _getMoodDescription(_selectedMoodLevel),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 8,
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 16,
                                        ),
                                        overlayShape: const RoundSliderOverlayShape(
                                          overlayRadius: 24,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _selectedMoodLevel.toDouble(),
                                        min: 0,
                                        max: 10,
                                        divisions: 10,
                                        activeColor: _getMoodColor(_selectedMoodLevel),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedMoodLevel = value.round();
                                            _selectedEmoji = _getEmojiForMood(_selectedMoodLevel);
                                          });
                                          _animationController.reset();
                                          _animationController.forward();
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('😢', style: TextStyle(fontSize: 24)),
                                        Text('😇', style: TextStyle(fontSize: 24)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Emoji Selector
                        const Text(
                          'Or pick an emoji that represents your mood:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<MoodProvider>(
                          builder: (context, moodProvider, child) {
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: moodProvider.availableEmojis.map((emoji) {
                                final isSelected = emoji == _selectedEmoji;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedEmoji = emoji;
                                      _selectedMoodLevel = moodProvider.availableEmojis.indexOf(emoji);
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primaryColor.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Journal Entry
                        const Text(
                          'What\'s on your mind? (optional)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _journalController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Share your thoughts, feelings, or what happened today...',
                            hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save Button
                Consumer<MoodProvider>(
                  builder: (context, moodProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: moodProvider.isLoading ? null : _saveMood,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: moodProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          widget.isOnboarding ? 'Continue' : 'Save Mood',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMoodDescription(int level) {
    switch (level) {
      case 0:
      case 1:
        return 'Very Low';
      case 2:
      case 3:
        return 'Low';
      case 4:
      case 5:
        return 'Neutral';
      case 6:
      case 7:
        return 'Good';
      case 8:
      case 9:
        return 'Great';
      case 10:
        return 'Amazing';
      default:
        return 'Neutral';
    }
  }

  String _getEmojiForMood(int level) {
    final emojis = ['😢', '😟', '😔', '😐', '🙂', '😊', '😄', '🤗', '😍', '🥰', '😇'];
    return emojis[level.clamp(0, emojis.length - 1)];
  }

  Color _getMoodColor(int level) {
    if (level <= 3) return AppTheme.errorColor;
    if (level <= 6) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  Future<void> _saveMood() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    final questProvider = Provider.of<QuestProvider>(context, listen: false);
    final treeProvider = Provider.of<HealingTreeProvider>(context, listen: false);

    if (authProvider.user == null) return;

    await moodProvider.saveMood(
      userId: authProvider.user!.id,
      moodLevel: _selectedMoodLevel,
      emoji: _selectedEmoji,
      journalEntry: _journalController.text.trim().isEmpty
          ? null
          : _journalController.text.trim(),
    );

    // Update healing tree based on mood
    await treeProvider.updateFromMoodImprovement(_selectedMoodLevel);

    // Assign appropriate quests
    await questProvider.assignQuestsBasedOnMood(_selectedMoodLevel, null);

    if (widget.isOnboarding) {
      await authProvider.completeOnboarding();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mood saved successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}