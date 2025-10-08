import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/story_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/healing_tree_provider.dart';
import 'providers/community_provider.dart';
import 'providers/ai_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'utils/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const MindMazeApp());
}

class MindMazeApp extends StatelessWidget {
  const MindMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
        ChangeNotifierProvider(create: (_) => HealingTreeProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'MindMaze',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
