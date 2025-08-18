import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/healing_tree_provider.dart';
import '../../models/healing_tree_model.dart';
import '../../utils/app_theme.dart';

class HealingTreeWidget extends StatefulWidget {
  const HealingTreeWidget({super.key});

  @override
  State<HealingTreeWidget> createState() => _HealingTreeWidgetState();
}

class _HealingTreeWidgetState extends State<HealingTreeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealingTreeProvider>(
      builder: (context, treeProvider, child) {
        final tree = treeProvider.healingTree;
        if (tree == null) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppTheme.primaryColor.withOpacity(0.05),
              ],
            ),
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
              // Tree Visualization
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _getTreeColor(tree.state),
                        borderRadius: BorderRadius.circular(60),
                        gradient: RadialGradient(
                          colors: [
                            _getTreeColor(tree.state).withOpacity(0.3),
                            _getTreeColor(tree.state).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getTreeEmoji(tree.state),
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tree Info
              Text(
                'Your Healing Tree',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tree.stateDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Level and Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Level', tree.level.toString()),
                  _buildStatCard('XP', tree.experience.toString()),
                  _buildStatCard('State', _getStateText(tree.state)),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress to next level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: treeProvider.progressToNextLevel,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTreeColor(tree.state),
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Color _getTreeColor(TreeState state) {
    switch (state) {
      case TreeState.withered:
        return Colors.brown;
      case TreeState.sprouting:
        return Colors.lightGreen;
      case TreeState.growing:
        return Colors.green;
      case TreeState.blooming:
        return Colors.pink;
      case TreeState.flourishing:
        return Colors.purple;
    }
  }

  String _getTreeEmoji(TreeState state) {
    switch (state) {
      case TreeState.withered:
        return '🥀';
      case TreeState.sprouting:
        return '🌱';
      case TreeState.growing:
        return '🌿';
      case TreeState.blooming:
        return '🌸';
      case TreeState.flourishing:
        return '🌺';
    }
  }

  String _getStateText(TreeState state) {
    switch (state) {
      case TreeState.withered:
        return 'Resting';
      case TreeState.sprouting:
        return 'Sprouting';
      case TreeState.growing:
        return 'Growing';
      case TreeState.blooming:
        return 'Blooming';
      case TreeState.flourishing:
        return 'Flourishing';
    }
  }
}