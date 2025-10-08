import 'package:flutter/material.dart';
import '../models/community_message_model.dart';
import '../utils/data_constants.dart';
import '../utils/local_storage_service.dart';
import '../utils/profanity_filter.dart';

class CommunityProvider extends ChangeNotifier {
  final List<CommunityMessage> _messages = [];
  final Map<String, DateTime> _bannedUsers = {}; // userId -> ban expiry

  List<CommunityMessage> get messages => List.unmodifiable(_messages);

  CommunityProvider() {
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final stored =
          LocalStorageService.readList(LocalStorageService.communityBox);
      if (stored.isEmpty) {
        _preloadMockPosts();
      } else {
        _messages
          ..clear()
          ..addAll(stored.map(CommunityMessage.fromMap));
      }
    } catch (e) {
      if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
        // simple log suppression for release; use debug print
        print('CommunityProvider hydrate error: $e');
      }
    }
    notifyListeners();
  }

  void _preloadMockPosts() {
    _messages
      ..clear()
      ..addAll(DataConstants.mockCommunityPosts
          .map((map) => CommunityMessage.fromMap(map)));
    _persist();
  }

  bool isUserBanned(String userId) {
    if (!_bannedUsers.containsKey(userId)) return false;
    final expiry = _bannedUsers[userId]!;
    if (DateTime.now().isAfter(expiry)) {
      _bannedUsers.remove(userId);
      return false;
    }
    return true;
  }

  Future<void> sendMessage(String userId, String message,
      {bool isAnonymous = true}) async {
    if (isUserBanned(userId)) {
      throw Exception('You are temporarily muted. Try again soon.');
    }

    final sanitized = message.trim();
    if (sanitized.isEmpty) {
      throw Exception('Message cannot be empty.');
    }

    if (ProfanityFilter.containsProfanity(sanitized)) {
      _bannedUsers[userId] =
          DateTime.now().add(const Duration(days: 3)); // ban 3 days
      throw Exception('Gentle reminder: our wall is a safe space. Please be kind.');
    }

    final newMessage = CommunityMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      message: sanitized,
      timestamp: DateTime.now(),
      isAnonymous: isAnonymous,
    );

    _messages.insert(0, newMessage);
    await _persist();
    notifyListeners();
  }

  Future<void> reactToMessage(String messageId, String emoji) async {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index == -1) return;

    final target = _messages[index];
    final updatedReactions = Map<String, int>.from(target.reactions);
    updatedReactions.update(emoji, (value) => value + 1, ifAbsent: () => 1);
    _messages[index] = target.copyWith(reactions: updatedReactions);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await LocalStorageService.saveList(
      LocalStorageService.communityBox,
      _messages.map((e) => e.toMap()).toList(),
    );
  }
}
