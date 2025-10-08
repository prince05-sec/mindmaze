import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String moodBox = 'mood_box';
  static const String chatBox = 'chat_box';
  static const String journalBox = 'journal_box';
  static const String questBox = 'quest_box';
  static const String treeBox = 'tree_box';
  static const String communityBox = 'community_box';
  static const String analyticsBox = 'analytics_box';
  static const String settingsBox = 'settings_box';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);

    await Future.wait([
      Hive.openBox(moodBox),
      Hive.openBox(chatBox),
      Hive.openBox(journalBox),
      Hive.openBox(questBox),
      Hive.openBox(treeBox),
      Hive.openBox(communityBox),
      Hive.openBox(analyticsBox),
      Hive.openBox(settingsBox),
    ]);

    _initialized = true;
  }

  static Box getBox(String boxName) {
    if (!_initialized) {
      throw StateError('LocalStorageService.init() must be called before accessing boxes.');
    }
    return Hive.box(boxName);
  }

  static Future<void> saveList(String boxName, List<Map<String, dynamic>> data) async {
    final box = getBox(boxName);
    await box.put('data', jsonEncode(data));
  }

  static List<Map<String, dynamic>> readList(String boxName) {
    final box = getBox(boxName);
    final raw = box.get('data');
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveMap(String boxName, Map<String, dynamic> data) async {
    final box = getBox(boxName);
    await box.put('data', jsonEncode(data));
  }

  static Map<String, dynamic>? readMap(String boxName) {
    final box = getBox(boxName);
    final raw = box.get('data');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clearBox(String boxName) async {
    final box = getBox(boxName);
    await box.clear();
  }
}
