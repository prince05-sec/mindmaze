import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'consent_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero Image/Animation
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.auto_stories,
                          size: 80,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Welcome Text
                      const Text(
                        'Welcome to MindMaze',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Embark on interactive story journeys that adapt to your emotions and guide you toward wellness',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondaryColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Features
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.mood,
                        title: 'Mood Tracking',
                        description: 'Track your emotions with simple, intuitive tools',
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureItem(
                        icon: Icons.book,
                        title: 'Adaptive Stories',
                        description: 'Experience personalized narratives that respond to you',
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureItem(
                        icon: Icons.local_florist,
                        title: 'Healing Journey',
                        description: 'Watch your wellness tree grow with every step',
                      ),
                    ],
                  ),
                ),

                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ConsentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Begin Your Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}