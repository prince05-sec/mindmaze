import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../main/main_screen.dart';
import '../main/mood_input_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Check if user has completed onboarding
        if (!authProvider.user!.hasCompletedOnboarding ||
            !authProvider.user!.hasAcceptedConsent) {
          return const MoodInputScreen(isOnboarding: true);
        }

        return const MainScreen();
      },
    );
  }
}