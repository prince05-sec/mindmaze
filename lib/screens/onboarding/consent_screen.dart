import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../auth/login_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _hasAcceptedConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Consent'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Your Privacy Matters',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Before we begin, please read and understand how we handle your data:',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Consent Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConsentSection(
                        icon: Icons.psychology,
                        title: 'Emotional & Mood Data',
                        content:
                            'We collect your mood inputs, journal entries, and emotional check-ins to personalize your stories and track your wellness journey.',
                      ),
                      const SizedBox(height: 24),

                      _buildConsentSection(
                        icon: Icons.auto_stories,
                        title: 'Story Interactions',
                        content:
                            'Your story choices and progress are saved to provide continuity and improve future story recommendations.',
                      ),
                      const SizedBox(height: 24),

                      _buildConsentSection(
                        icon: Icons.security,
                        title: 'Data Security',
                        content:
                            'All data is encrypted and securely stored. We never share your personal information with third parties without your explicit consent.',
                      ),
                      const SizedBox(height: 24),

                      _buildConsentSection(
                        icon: Icons.volunteer_activism,
                        title: 'Professional Support',
                        content:
                            'MindMaze is a wellness companion, not a replacement for professional mental health care. If you\'re in crisis, please seek immediate help.',
                      ),
                      const SizedBox(height: 32),

                      // Crisis Resources
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.warningColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.emergency,
                                  color: AppTheme.warningColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Crisis Resources',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'National Suicide Prevention Lifeline: 988\nCrisis Text Line: Text HOME to 741741\nEmergency: 911',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Consent Checkbox
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _hasAcceptedConsent,
                    onChanged: (value) {
                      setState(() {
                        _hasAcceptedConsent = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'I have read and agree to the data collection practices described above. I understand that MindMaze is a wellness tool and not a substitute for professional mental health care.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasAcceptedConsent ? _handleContinue : null,
                  child: const Text(
                    'Continue to Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
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
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
