import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../providers/mood_provider.dart';
import '../../providers/quest_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/healing_tree_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.defaultGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(context),
                const SizedBox(height: 32),
                _buildStatsSection(context),
                const SizedBox(height: 32),
                _buildSettingsSection(context),
                const SizedBox(height: 32),
                _buildAchievementsPreview(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Mindful Explorer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Journey started ${DateTime.now().difference(DateTime(2024, 1, 1)).inDays} days ago',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer4<MoodProvider, QuestProvider, JournalProvider,
        HealingTreeProvider>(
      builder: (context, moodProvider, questProvider, journalProvider,
          treeProvider, child) {
        final totalMoods = moodProvider.moodHistory.length;
        final totalQuests = questProvider.totalCompletedQuests;
        final totalJournals = journalProvider.entries.length;
        final treeLevel = treeProvider.healingTree?.level ?? 1;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Journey',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.mood,
                    value: totalMoods.toString(),
                    label: 'Mood\nEntries',
                    color: AppTheme.primaryColor,
                  ),
                  _buildStatItem(
                    icon: Icons.assignment_turned_in,
                    value: totalQuests.toString(),
                    label: 'Quests\nCompleted',
                    color: AppTheme.successColor,
                  ),
                  _buildStatItem(
                    icon: Icons.book,
                    value: totalJournals.toString(),
                    label: 'Journal\nEntries',
                    color: AppTheme.secondaryColor,
                  ),
                  _buildStatItem(
                    icon: Icons.nature,
                    value: treeLevel.toString(),
                    label: 'Tree\nLevel',
                    color: AppTheme.accentColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingItem(
            icon: Icons.brightness_6,
            title: 'Theme',
            subtitle: 'Light / Dark / Adaptive',
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(height: 32),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Daily reminders & insights',
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Privacy',
            subtitle: 'Data & privacy settings',
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'FAQs and contact',
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Exit your account',
            onTap: () {},
            textColor: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
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
                      color: textColor ?? AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsPreview(BuildContext context) {
    return Consumer<QuestProvider>(
      builder: (context, questProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full achievements screen
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAchievementBadge(
                    emoji: '🎯',
                    title: 'First Quest',
                    unlocked: questProvider.totalCompletedQuests >= 1,
                  ),
                  _buildAchievementBadge(
                    emoji: '🔥',
                    title: 'Quest Master',
                    unlocked: questProvider.totalCompletedQuests >= 5,
                  ),
                  _buildAchievementBadge(
                    emoji: '📝',
                    title: 'Reflective',
                    unlocked:
                        Provider.of<JournalProvider>(context).entries.length >=
                            5,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementBadge({
    required String emoji,
    required String title,
    required bool unlocked,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: unlocked
                ? AppTheme.successColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unlocked
                  ? AppTheme.successColor.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 24,
                color: unlocked ? null : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: unlocked ? AppTheme.textPrimaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Light Theme'),
                      value: 'light',
                      groupValue: themeProvider.currentMode,
                      onChanged: (value) {
                        themeProvider.setThemeMode('light');
                        AdaptiveTheme.of(context).setLight();
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Dark Theme'),
                      value: 'dark',
                      groupValue: themeProvider.currentMode,
                      onChanged: (value) {
                        themeProvider.setThemeMode('dark');
                        AdaptiveTheme.of(context).setDark();
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Adaptive'),
                      value: 'adaptive',
                      groupValue: themeProvider.currentMode,
                      onChanged: (value) {
                        themeProvider.setThemeMode('adaptive');
                        AdaptiveTheme.of(context).setSystem();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
