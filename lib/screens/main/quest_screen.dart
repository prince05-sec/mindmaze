import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/quest_provider.dart';
import '../../providers/healing_tree_provider.dart';
import '../../providers/mood_provider.dart';
import '../../providers/story_provider.dart';
import '../../utils/app_theme.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        'Wellness Quests',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryColor,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Active'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActiveQuestsTab(),
                    _buildCompletedQuestsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Tabs ----------------

  Widget _buildActiveQuestsTab() {
    return Consumer<QuestProvider>(
      builder: (context, questProvider, child) {
        if (questProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (questProvider.activeQuests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ready for your quest?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Complete your mood check-in to unlock personalized wellness quests tailored to your current state.',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/mood-input'),
                    icon: const Icon(Icons.mood),
                    label: const Text('Check My Mood'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: questProvider.activeQuests.length,
          itemBuilder: (context, index) {
            final userQuest = questProvider.activeQuests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildQuestCard(userQuest, false),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedQuestsTab() {
    return Consumer<QuestProvider>(
      builder: (context, questProvider, child) {
        if (questProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (questProvider.completedQuests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('📝', style: TextStyle(fontSize: 80)),
                SizedBox(height: 16),
                Text(
                  'No completed quests yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Complete some quests to see them here',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: questProvider.completedQuests.length,
          itemBuilder: (context, index) {
            final userQuest = questProvider.completedQuests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildQuestCard(userQuest, true),
            );
          },
        );
      },
    );
  }

  // ---------------- Widgets ----------------

  /// Card for a single quest (active or completed)
  Widget _buildQuestCard(dynamic userQuest, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(color: AppTheme.successColor.withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    userQuest.quest.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userQuest.quest.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            userQuest.quest.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${userQuest.quest.estimatedMinutes} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userQuest.quest.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (!isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // TODO: wire this to your provider method, e.g. questProvider.complete(userQuest)
                onPressed: () async {
                  // Add completion animation
                  final questProvider = context.read<QuestProvider>();
                  await questProvider.completeQuest(userQuest.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quest completed! 🎉'),
                      backgroundColor: AppTheme.successColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Mark as Complete',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            )
          else if (userQuest.completedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Completed: ${_formatDate(userQuest.completedAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      String emoji, String title, String description, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.successColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 32,
              color: isUnlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked ? AppTheme.textPrimaryColor : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isUnlocked ? AppTheme.textSecondaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isUnlocked ? Icons.check_circle : Icons.lock,
            color: isUnlocked ? AppTheme.successColor : Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Quest achievements
          Consumer<QuestProvider>(
            builder: (context, questProvider, child) {
              return Column(
                children: [
                  _buildAchievementCard(
                    '🎯',
                    'First Quest',
                    'Complete your first wellness quest',
                    questProvider.totalCompletedQuests >= 1,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '🔥',
                    'Quest Master',
                    'Complete 5 wellness quests',
                    questProvider.totalCompletedQuests >= 5,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '💪',
                    'Dedicated Wellness',
                    'Complete 10 wellness quests',
                    questProvider.totalCompletedQuests >= 10,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Mood achievements
          Consumer<MoodProvider>(
            builder: (context, moodProvider, child) {
              return Column(
                children: [
                  _buildAchievementCard(
                    '📝',
                    'First Check-in',
                    'Record your first mood entry',
                    moodProvider.moodHistory.isNotEmpty,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '📊',
                    'Consistent Tracker',
                    'Record mood for 7 days',
                    moodProvider.moodHistory.length >= 7,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '🌟',
                    'Mood Master',
                    'Record 30 mood entries',
                    moodProvider.moodHistory.length >= 30,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Story achievements
          Consumer<StoryProvider>(
            builder: (context, storyProvider, child) {
              return Column(
                children: [
                  _buildAchievementCard(
                    '📚',
                    'Storyteller',
                    'Complete your first story journey',
                    storyProvider.hasCompletedStory,
                  ),
                  // Removed "Path Walker" that referenced unknown currentProgress
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Healing Tree achievements
          Consumer<HealingTreeProvider>(
            builder: (context, treeProvider, child) {
              final tree = treeProvider.healingTree;
              return Column(
                children: [
                  _buildAchievementCard(
                    '🌱',
                    'New Growth',
                    'Reach tree level 2',
                    tree != null && tree.level >= 2,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '🌸',
                    'Blooming',
                    'Reach tree level 5',
                    tree != null && tree.level >= 5,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    '🌺',
                    'Flourishing',
                    'Reach tree level 10',
                    tree != null && tree.level >= 10,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Utils ----------------

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
