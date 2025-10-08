import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/journal_entry_model.dart';
import '../utils/ai_engine.dart';
import '../utils/local_storage_service.dart';

class JournalProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<JournalEntry> _entries = [];
  bool _isLoading = false;

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  JournalProvider() {
    _hydrate();
  }

  Future<void> _hydrate() async {
    _setLoading(true);
    try {
      final raw = LocalStorageService.readList(LocalStorageService.journalBox);
      _entries
        ..clear()
        ..addAll(raw.map(JournalEntry.fromMap));
    } catch (e) {
      if (kDebugMode) {
        print('JournalProvider hydrate error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addEntry({
    required String mood,
    required String entry,
    List<String> tags = const [],
    bool isVoice = false,
    String? transcript,
  }) async {
    try {
      final tone = transcript != null && transcript.isNotEmpty
          ? AiEngine.analyzeTone(transcript)
          : AiEngine.analyzeTone(entry);

      final journal = JournalEntry(
        id: _uuid.v4(),
        date: DateTime.now(),
        mood: mood,
        entry: entry,
        tags: tags,
        isVoice: isVoice,
        transcript: transcript,
        tone: tone,
      );

      _entries.insert(0, journal);
      notifyListeners();
      await _persist();
    } catch (e) {
      // Revert the UI change if persistence fails
      _entries.removeAt(0);
      notifyListeners();
      rethrow; // Let the caller handle the error
    }
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> clearAll() async {
    _entries.clear();
    notifyListeners();
    await LocalStorageService.clearBox(LocalStorageService.journalBox);
  }

  Future<void> _persist() async {
    await LocalStorageService.saveList(
      LocalStorageService.journalBox,
      _entries.map((e) => e.toMap()).toList(),
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
