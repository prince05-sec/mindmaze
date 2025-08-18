import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/story_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/healing_tree_provider.dart';
import '../../utils/app_theme.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              Color(0xFF2D1B69),
              Color(0xFF6B73FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<StoryProvider>(
            builder: (context, storyProvider, child) {
              if (storyProvider.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              final currentScene = storyProvider.getCurrentScene();
              final hasActiveStory = storyProvider.hasActiveStory;
              final hasCompletedStory = storyProvider.hasCompletedStory;

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Your Story Journey',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (!hasActiveStory && !hasCompletedStory) ...[
                      // Start New Story
                      _buildStartStoryCard(),
                    ] else if (hasActiveStory && currentScene != null) ...[
                      // Continue Story
                      Expanded(child: _buildStoryContent(currentScene, storyProvider)),
                    ] else if (hasCompletedStory) ...[
                      // Story Completed
                      _buildCompletedStoryCard(),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStartStoryCard() {
    return Expanded(
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🌟',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Begin Your Journey',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Embark on a personalized story that adapts to your emotions and guides you toward inner peace and wisdom.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startNewStory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Start Story',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryContent(dynamic currentScene, StoryProvider storyProvider) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Story Text
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentScene.text,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    if (currentScene.choices.isEmpty) ...[
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          '✨ The End ✨',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Story Choices
          if (currentScene.choices.isNotEmpty) ...[
            const SizedBox(height: 24),
            ...currentScene.choices.map<Widget>((choice) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _makeChoice(choice, storyProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      elevation: 0,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                      choice.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ] else ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _completeStory(storyProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Continue Your Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedStoryCard() {
    return Expanded(
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎉',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Story Complete!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'You\'ve completed your story journey! Your choices have shaped your path and contributed to your healing tree\'s growth.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startNewStory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Start New Story',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startNewStory() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);

    if (authProvider.user != null) {
      storyProvider.startNewStory(authProvider.user!.id);
    }
  }

  void _makeChoice(dynamic choice, StoryProvider storyProvider) {
    storyProvider.makeChoice(choice.label, choice.nextSceneId);

    // Animate to new scene
    _animationController.reset();
    _animationController.forward();
  }

  void _completeStory(StoryProvider storyProvider) {
    final treeProvider = Provider.of<HealingTreeProvider>(context, listen: false);
    final currentScene = storyProvider.getCurrentScene();

    if (currentScene != null) {
      treeProvider.updateFromStoryEnding(currentScene.moodEffect);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your healing tree has grown from this journey!'),
        backgroundColor: AppTheme.successColor,
      ),
    );

    Navigator.of(context).pop();
  }
}