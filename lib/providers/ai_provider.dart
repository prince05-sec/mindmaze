import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_message_model.dart';
import '../utils/ai_engine.dart';
import '../utils/local_storage_service.dart';

class AiProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<AiMessage> _messages = [];
  bool _isProcessing = false;

  List<AiMessage> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;

  AiProvider() {
    _hydrateFromStorage();
  }

  Future<void> _hydrateFromStorage() async {
    try {
      final rawList = LocalStorageService.readList(LocalStorageService.chatBox);
      _messages
        ..clear()
        ..addAll(rawList.map(AiMessage.fromMap));
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('AiProvider hydrate error: $e');
      }
    }
  }

  Future<void> _persist() async {
    await LocalStorageService.saveList(
      LocalStorageService.chatBox,
      _messages.map((m) => m.toMap()).toList(),
    );
  }

  Future<AiAnalysisResult> sendMessage(String content) async {
    _setProcessing(true);

    final userMessage = AiMessage(
      id: _uuid.v4(),
      isUser: true,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    notifyListeners();
    await _persist();

    final analysis = AiEngine.analyzeInput(content);
    final aiText = _composeAiResponse(analysis);

    final aiMessage = AiMessage(
      id: _uuid.v4(),
      isUser: false,
      content: aiText,
      timestamp: DateTime.now(),
      moodTag: analysis.moodTag,
    );

    _messages.add(aiMessage);
    await _persist();
    _setProcessing(false);

    return analysis;
  }

  Future<String> simulateVoiceInput(String transcript) async {
    final analysis = await sendMessage(transcript);
    return analysis.moodTag;
  }

  Future<void> clearConversation() async {
    _messages.clear();
    notifyListeners();
    await LocalStorageService.clearBox(LocalStorageService.chatBox);
  }

  String dailyAffirmation(String moodTag) {
    return AiEngine.getAffirmation(moodTag);
  }

  String _composeAiResponse(AiAnalysisResult analysis) {
    return '${analysis.response}\n\n${analysis.followUp}';
  }

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
}
