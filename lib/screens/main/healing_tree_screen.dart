import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/healing_tree_provider.dart';
import '../../utils/app_theme.dart';

class HealingTreeScreen extends StatefulWidget {
  const HealingTreeScreen({super.key});

  @override
  State<HealingTreeScreen> createState() => _HealingTreeScreenState();
}

class _HealingTreeScreenState extends State<HealingTreeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healing Tree'),
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
        child: Consumer<HealingTreeProvider>(
          builder: (context, provider, child) {
            final tree = provider.healingTree;
            if (provider.isLoading || tree == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                const SizedBox(height: 32),
                SizedBox(
                  height: 320,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _TreePainter(
                          level: tree.level,
                          progress: provider.progressToNextLevel,
                          sway: sin(_controller.value * pi) * 0.1,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatsCard(tree.level, provider.progressToNextLevel, tree.stateDescription),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildActionButtons(provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard(int level, double progress, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
          const Text(
            'Tree Wisdom',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      color: AppTheme.primaryColor,
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(HealingTreeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.updateTreeProgress(
            eventType: 'mindful_breath',
            experienceGain: 8,
          ),
          icon: const Icon(Icons.spa),
          label: const Text('Log Mindful Breath'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => provider.updateTreeProgress(
            eventType: 'gratitude_note',
            experienceGain: 12,
          ),
          icon: const Icon(Icons.favorite),
          label: const Text('Honor Gratitude Moment'),
        ),
      ],
    );
  }
}

class _TreePainter extends CustomPainter {
  final int level;
  final double progress;
  final double sway;

  _TreePainter({
    required this.level,
    required this.progress,
    required this.sway,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    final trunkPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final branchPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFFA5D6A7)
      ..style = PaintingStyle.fill;

    // Draw trunk with sway
    final trunkTop = Offset(
      center.dx + sway * 20,
      center.dy - 160,
    );
    canvas.drawLine(center, trunkTop, trunkPaint);

    // Draw branches level dependent
    final branchLevels = min(level, 5);
    for (int i = 0; i < branchLevels; i++) {
      final angle = -pi / 4 + (i * (pi / 8));
      final start = Offset(
        center.dx + sway * 10,
        center.dy - 80 - (i * 18),
      );
      final end = Offset(
        start.dx + cos(angle + sway) * 80,
        start.dy + sin(angle + sway) * 60,
      );
      canvas.drawLine(start, end, branchPaint);
      canvas.drawCircle(end, 18 + (progress * 12), leafPaint);
    }

    // Canopy glow based on progress
    final canopyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFB2FF59).withOpacity(0.2 + progress * 0.3),
          Colors.transparent,
        ],
        radius: 0.6,
      ).createShader(
        Rect.fromCircle(
          center: Offset(trunkTop.dx, trunkTop.dy - 20),
          radius: 120,
        ),
      );
    canvas.drawCircle(Offset(trunkTop.dx, trunkTop.dy - 20), 120, canopyPaint);
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.progress != progress ||
        oldDelegate.sway != sway;
  }
}
