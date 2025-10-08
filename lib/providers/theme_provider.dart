import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _followMood = true;
  String? _overrideMood;
  String _themeMode = 'adaptive'; // 'light', 'dark', 'adaptive'

  bool get followMood => _followMood;
  String? get overrideMood => _overrideMood;
  String get currentMode => _themeMode;

  ThemeProvider() {
    _hydrate();
  }

  Future<void> _hydrate() async {
    final stored =
        await LocalStorageService.readMap(LocalStorageService.settingsBox);
    if (stored != null) {
      _followMood = stored['followMood'] as bool? ?? true;
      _overrideMood = stored['overrideMood'] as String?;
      _themeMode = stored['themeMode'] as String? ?? 'adaptive';
      notifyListeners();
    }
  }

  Future<void> setFollowMood(bool value) async {
    _followMood = value;
    if (!value) {
      _overrideMood ??= 'calm';
    }
    await _persist();
    notifyListeners();
  }

  Future<void> setOverrideMood(String? moodTag) async {
    _overrideMood = moodTag;
    await _persist();
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _persist();
    notifyListeners();
  }

  LinearGradient getGradient(String? currentMoodTag) {
    final moodTag =
        _followMood ? (currentMoodTag ?? 'calm') : (_overrideMood ?? 'calm');

    switch (moodTag) {
      case 'sad':
        return const LinearGradient(
          colors: [Color(0xFF9FB6FF), Color(0xFFDDEBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'happy':
        return const LinearGradient(
          colors: [Color(0xFFFFEAA7), Color(0xFFFFC6A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'calm':
      default:
        return const LinearGradient(
          colors: [AppTheme.backgroundColor, Color(0xFFE6F3FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Future<void> _persist() async {
    await LocalStorageService.saveMap(LocalStorageService.settingsBox, {
      'followMood': _followMood,
      'overrideMood': _overrideMood,
      'themeMode': _themeMode,
    });
  }
}
