import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/story_model.dart';

class StoryProvider with ChangeNotifier {
  Map<String, StoryScene> _storyScenes = {};
  UserStoryProgress? _currentProgress;
  bool _isLoading = false;

  Map<String, StoryScene> get storyScenes => _storyScenes;
  UserStoryProgress? get currentProgress => _currentProgress;
  bool get isLoading => _isLoading;

  StoryProvider() {
    _loadStoryContent();
  }

  Future<void> _loadStoryContent() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load default story content
      _storyScenes = {
        'intro': StoryScene(
          id: 'intro',
          text: 'You find yourself standing at the edge of a mystical forest. Ancient trees tower above you, their branches forming a natural cathedral. The air shimmers with possibility, and you feel a gentle pull toward two distinct paths ahead. Each path seems to whisper its own invitation.',
          choices: [
            StoryChoice(
              label: '🌸 Take the sunlit path lined with blooming flowers',
              nextSceneId: 'path_light',
            ),
            StoryChoice(
              label: '🌙 Follow the moonlit trail through the shadows',
              nextSceneId: 'path_shadow',
            ),
            StoryChoice(
              label: '💫 Sit quietly and listen to the forest\'s wisdom',
              nextSceneId: 'path_meditation',
            ),
          ],
          moodEffect: 'curious',
        ),
        'path_light': StoryScene(
          id: 'path_light',
          text: 'The sunlit path welcomes you with warmth and vibrant colors. Butterflies dance around blooming wildflowers, and a gentle breeze carries the sweet scent of jasmine. As you walk, you notice a small clearing ahead where a crystal-clear stream flows peacefully.',
          choices: [
            StoryChoice(
              label: '🦋 Follow the butterflies to a hidden garden',
              nextSceneId: 'garden_discovery',
            ),
            StoryChoice(
              label: '💧 Kneel by the stream and reflect',
              nextSceneId: 'stream_reflection',
            ),
          ],
          moodEffect: 'uplifted',
        ),
        'path_shadow': StoryScene(
          id: 'path_shadow',
          text: 'The moonlit path leads you through a realm of silver shadows and gentle mysteries. Fireflies create tiny lanterns in the darkness, and you hear the soft hooting of a wise owl. The path winds deeper into the forest, where ancient stones form a circle.',
          choices: [
            StoryChoice(
              label: '🦉 Approach the wise owl for guidance',
              nextSceneId: 'owl_wisdom',
            ),
            StoryChoice(
              label: '🗿 Enter the ancient stone circle',
              nextSceneId: 'stone_circle',
            ),
          ],
          moodEffect: 'contemplative',
        ),
        'path_meditation': StoryScene(
          id: 'path_meditation',
          text: 'You settle into a comfortable position and close your eyes. The forest seems to embrace you with its gentle sounds - rustling leaves, distant bird songs, and the soft whisper of wind. Gradually, you feel a deep sense of peace washing over you.',
          choices: [
            StoryChoice(
              label: '🧘‍♀️ Continue meditating and go deeper',
              nextSceneId: 'deep_meditation',
            ),
            StoryChoice(
              label: '🌱 Open your eyes and notice what has changed',
              nextSceneId: 'awakened_awareness',
            ),
          ],
          moodEffect: 'peaceful',
        ),
        'garden_discovery': StoryScene(
          id: 'garden_discovery',
          text: 'The butterflies lead you to a secret garden where every flower seems to glow with inner light. In the center grows a magnificent tree with golden leaves. A gentle voice seems to whisper from the tree: "Plant a seed of kindness in your daily life."',
          choices: [
            StoryChoice(
              label: '🌻 Promise to show kindness to someone today',
              nextSceneId: 'ending_light',
            ),
          ],
          moodEffect: 'inspired',
        ),
        'stream_reflection': StoryScene(
          id: 'stream_reflection',
          text: 'As you kneel by the crystal stream, your reflection appears not as you are, but as you could become - confident, peaceful, and radiant. The water seems to whisper: "You already have everything you need within you."',
          choices: [
            StoryChoice(
              label: '💎 Embrace your inner strength',
              nextSceneId: 'ending_light',
            ),
          ],
          moodEffect: 'empowered',
        ),
        'owl_wisdom': StoryScene(
          id: 'owl_wisdom',
          text: 'The wise owl perches near you and speaks in a voice like rustling leaves: "In darkness, we learn to see with our hearts. What truth do you seek?" You realize that sometimes our challenges are our greatest teachers.',
          choices: [
            StoryChoice(
              label: '🔍 Commit to learning from your challenges',
              nextSceneId: 'ending_shadow',
            ),
          ],
          moodEffect: 'enlightened',
        ),
        'stone_circle': StoryScene(
          id: 'stone_circle',
          text: 'Within the ancient stone circle, you feel connected to countless souls who have stood here before. The stones seem to pulse with accumulated wisdom: "You are part of something greater than yourself."',
          choices: [
            StoryChoice(
              label: '🌍 Feel your connection to all beings',
              nextSceneId: 'ending_shadow',
            ),
          ],
          moodEffect: 'connected',
        ),
        'deep_meditation': StoryScene(
          id: 'deep_meditation',
          text: 'In the depths of meditation, you discover a profound truth: peace is not the absence of chaos, but the presence of calm within it. You carry this wisdom back with you.',
          choices: [
            StoryChoice(
              label: '☮️ Integrate this peace into your daily life',
              nextSceneId: 'ending_meditation',
            ),
          ],
          moodEffect: 'serene',
        ),
        'awakened_awareness': StoryScene(
          id: 'awakened_awareness',
          text: 'Opening your eyes, you notice the forest has transformed. Every leaf, every ray of light seems more vivid. You realize that the magic was not in the forest, but in your awakened awareness.',
          choices: [
            StoryChoice(
              label: '✨ Carry this awareness into your day',
              nextSceneId: 'ending_meditation',
            ),
          ],
          moodEffect: 'awakened',
        ),
        'ending_light': StoryScene(
          id: 'ending_light',
          text: 'As you prepare to leave the forest, you feel lighter and more hopeful. The path back is illuminated with golden light, and you know that you can return to this feeling whenever you need it. Your healing tree has grown new blossoms.',
          choices: [],
          moodEffect: 'hopeful',
        ),
        'ending_shadow': StoryScene(
          id: 'ending_shadow',
          text: 'The forest has taught you to find wisdom in quiet moments and strength in reflection. As you return to your daily life, you carry with you a deeper understanding of yourself. Your healing tree has grown stronger roots.',
          choices: [],
          moodEffect: 'wise',
        ),
        'ending_meditation': StoryScene(
          id: 'ending_meditation',
          text: 'The forest fades around you, but the peace remains within. You have discovered that tranquility is always available to you, just a breath away. Your healing tree radiates calm energy.',
          choices: [],
          moodEffect: 'tranquil',
        ),
      };

      await _loadUserProgress();

    } catch (e) {
      print('Error loading story content: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('story_progress');

      if (progressJson != null) {
        _currentProgress = UserStoryProgress.fromMap(json.decode(progressJson));
      }
    } catch (e) {
      print('Error loading story progress: $e');
    }
  }

  Future<void> startNewStory(String userId) async {
    _currentProgress = UserStoryProgress(
      userId: userId,
      storyId: 'main_story',
      currentSceneId: 'intro',
      lastUpdated: DateTime.now(),
    );

    await _saveProgress();
    notifyListeners();
  }

  Future<void> makeChoice(String choiceLabel, String nextSceneId) async {
    if (_currentProgress == null) return;

    final newVisitedScenes = List<String>.from(_currentProgress!.visitedScenes);
    newVisitedScenes.add(_currentProgress!.currentSceneId);

    final newChoicesMade = List<String>.from(_currentProgress!.choicesMade);
    newChoicesMade.add(choiceLabel);

    final isCompleted = _storyScenes[nextSceneId]?.choices.isEmpty ?? false;

    _currentProgress = _currentProgress!.copyWith(
      currentSceneId: nextSceneId,
      visitedScenes: newVisitedScenes,
      choicesMade: newChoicesMade,
      isCompleted: isCompleted,
    );

    await _saveProgress();
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    if (_currentProgress == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('story_progress', json.encode(_currentProgress!.toMap()));
    } catch (e) {
      print('Error saving story progress: $e');
    }
  }

  StoryScene? getCurrentScene() {
    if (_currentProgress == null) return null;
    return _storyScenes[_currentProgress!.currentSceneId];
  }

  bool get hasActiveStory => _currentProgress != null && !_currentProgress!.isCompleted;
  bool get hasCompletedStory => _currentProgress?.isCompleted ?? false;

  List<String> getStoryPath() {
    if (_currentProgress == null) return [];
    return [
      ..._currentProgress!.visitedScenes,
      _currentProgress!.currentSceneId,
    ];
  }
}