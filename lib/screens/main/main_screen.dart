import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../providers/mood_provider.dart';
import '../../widgets/mood_chart_widget.dart';
import '../../providers/ai_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/data_constants.dart';
import '../../utils/app_theme.dart';
import '../../widgets/breathing_widget.dart';
import 'quest_generator_screen.dart';

import 'mood_input_screen.dart';
import 'quest_screen.dart';
import 'mood_chart_screen.dart';
import 'companion_screen.dart';
import 'community_wall_screen.dart';
import 'journal_screen.dart';
import 'healing_tree_screen.dart';
import 'profile_screen.dart';

String _emojiToMood(String? emoji) {
  if (emoji == null) return 'neutral';
  if (['😢', '😟', '😔'].contains(emoji)) return 'sad';
  if (['🙂', '😊'].contains(emoji)) return 'calm';
  if (['😄', '🤗', '😍', '🥰', '😇'].contains(emoji)) return 'happy';
  if (['😐'].contains(emoji)) return 'neutral';
  return 'neutral';
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeTab(),
      JournalScreen(),
      MoodChartScreen(),
      QuestScreen(),
      CompanionScreen(),
      CommunityWallScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Companion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<MoodProvider, ThemeProvider>(
        builder: (context, moodProvider, themeProvider, child) {
          // Use a soft default gradient instead of mood-based
          final gradient = AppTheme.defaultGradient;
          final currentMoodTag = _emojiToMood(moodProvider.currentMood?.emoji);

          return Container(
            decoration: BoxDecoration(gradient: gradient),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Focus',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Take a moment to breathe deeply and set a positive intention for your day.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : AppTheme.textSecondaryColor,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const MoodInputScreen()),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primaryColor,
                                  elevation: 2,
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text('Start Check-in'),
                              )
                                  .animate()
                                  .fadeIn(delay: 200.ms, duration: 600.ms)
                                  .scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1.0, 1.0))
                                  .then()
                                  .shimmer(delay: 1000.ms, duration: 1500.ms),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                          ),
                          onPressed: () => _showProfileMenu(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.emoji_emotions_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              themeProvider.followMood
                                  ? 'Theme is following your current mood.'
                                  : 'Theme locked to ${themeProvider.overrideMood?.toUpperCase() ?? 'CALM'} mood.',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    Container(
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
                        children: const [
                          Text(
                            'Wellness Dashboard',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Track your emotional journey and explore mindful tools curated for you.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    _buildMoodOverview(context),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildBreathingCard(),
                    const SizedBox(height: 24),
                    _buildAffirmationCard(context),
                    const SizedBox(height: 24),
                    _buildGratitudePromptCard(currentMoodTag),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodOverview(BuildContext context) {
    return Consumer<MoodProvider>(
      builder: (context, provider, child) {
        final moods = provider.moodHistory.take(7).toList();
        return MoodChartWidget(moods: moods);
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _QuickActionCard(
          title: 'Daily Quest',
          subtitle: 'AI-guided gentle challenge',
          icon: Icons.auto_awesome,
          delay: 500.ms,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const QuestGeneratorScreen()),
          ),
        ),
        _QuickActionCard(
          title: 'Journal Sanctuary',
          subtitle: 'Browse your entries',
          icon: Icons.book_rounded,
          delay: 600.ms,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const JournalScreen()),
          ),
        ),
        _QuickActionCard(
          title: 'Healing Tree',
          subtitle: 'Witness your growth',
          icon: Icons.nature,
          delay: 700.ms,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HealingTreeScreen()),
          ),
        ),
      ],
    );
  }

  // Simple quick action card used in the home grid
  Widget _QuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Duration delay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: AppTheme.primaryColor),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondaryColor)),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: delay, duration: 600.ms)
          .slideY(begin: 0.3, end: 0)
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildBreathingCard() {
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
        children: const [
          Text(
            'Guided Breathing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: BreathingWidget(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAffirmationCard(BuildContext context) {
    return Consumer<AiProvider>(
      builder: (context, aiProvider, child) {
        final recentMood = context.watch<MoodProvider>().currentMood;
        final moodTag = _emojiToMood(recentMood?.emoji);
        final affirmation = aiProvider.dailyAffirmation(moodTag);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B73FF), Color(0xFF9DCEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Affirmation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                affirmation,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildGratitudePromptCard(String moodTag) {
    final prompts = DataConstants.gratitudePrompts;
    final index = DateTime.now().day % prompts.length;
    final prompt = prompts[index];

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
          Row(
            children: const [
              Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Gratitude Prompt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prompt,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings, color: AppTheme.primaryColor),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: AppTheme.primaryColor),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorColor),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
