import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/story_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/healing_tree_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        title: 'MindMaze',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}