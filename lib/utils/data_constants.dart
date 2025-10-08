class DataConstants {
  static const Map<String, List<String>> emotionKeywords = {
    'sad': ['sad', 'down', 'unhappy', 'lost', 'lonely', 'tired'],
    'anxious': ['anxious', 'nervous', 'scared', 'worried', 'overwhelmed'],
    'angry': ['angry', 'upset', 'frustrated', 'mad', 'irritated'],
    'calm': ['calm', 'peaceful', 'relaxed', 'steady'],
    'happy': ['happy', 'joyful', 'excited', 'grateful', 'proud'],
    'neutral': ['okay', 'fine', 'meh', 'alright'],
  };

  static const Map<String, String> aiResponses = {
    'sad': "It's okay to feel sad sometimes. Take a deep breath, hold yourself with kindness, and remember you are not alone.",
    'anxious': "Anxiety can feel heavy. Try grounding yourself by noticing five things you can see, four you can touch, three you can hear.",
    'angry': "Anger shows how deeply you care. Pause, stretch your shoulders, and write what you wish you could say with compassion.",
    'calm': "I sense a calm energy from you. Savor this moment by placing your hand on your heart and breathing gently.",
    'happy': "Your joy is radiant! Consider sharing a kind message with someone you appreciate today.",
    'neutral': "Thank you for checking in. How about setting a small intention for the next hour?"
  };

  static const Map<String, List<String>> followUpQuestions = {
    'sad': [
      'Would you like to explore a gentle breathing exercise?',
      'Can you recall a moment today that brought a hint of comfort?'
    ],
    'anxious': [
      'Would writing down your worries help release them a bit?',
      'Can we try a grounding technique together?'
    ],
    'angry': [
      'Is there a safe way to express or release that energy?',
      'Maybe a brisk walk or shaking out your hands could help. Shall we try?'
    ],
    'calm': [
      'Would you like to store this peaceful feeling in your journal?',
      'Should we plan a small ritual to keep this calm tomorrow?'
    ],
    'happy': [
      'Can we capture this joy in a gratitude note?',
      'Who would you like to share a positive message with?'
    ],
    'neutral': [
      'Would a short gratitude prompt feel supportive?',
      'Shall we set a mindful intention for the evening?'
    ],
  };

  static const List<String> gratitudePrompts = [
    'Name three tiny sparks of joy you noticed today.',
    'What is one act of kindness you can offer yourself right now?',
    'Which part of your body supported you the most today?',
    'Recall a sound that made you smile recently.',
  ];

  static const Map<String, String> moodThemes = {
    'sad': '#D9C7FF',
    'anxious': '#C2E9FB',
    'angry': '#FFD6A5',
    'calm': '#C3FBD8',
    'happy': '#FFF5BA',
    'neutral': '#E7F0FD',
  };

  static const Map<String, String> breathingPatterns = {
    'inhale': '4',
    'hold': '4',
    'exhale': '6',
  };

  static const Map<String, String> questSuggestions = {
    'sad': 'Try writing three things you are grateful for.',
    'anxious': 'Spend five minutes focusing on slow breathing.',
    'angry': 'Take a brisk walk and notice five things you can see.',
    'calm': 'Light a candle and enjoy a quiet moment of reflection.',
    'happy': 'Share positivity — compliment someone today.',
    'neutral': 'Stretch gently and drink a glass of water mindfully.',
  };

  static const List<Map<String, dynamic>> mockCommunityPosts = [
    {
      'id': 'mock1',
      'userId': 'community_ally',
      'message': 'Sending soft hugs to anyone who feels heavy today. You are seen.',
      'timestamp': '2025-01-03T10:15:00Z'
    },
    {
      'id': 'mock2',
      'userId': 'quiet_sun',
      'message': 'Today I celebrated taking one mindful breath. Proud of the tiny steps.',
      'timestamp': '2025-01-04T08:50:00Z'
    },
    {
      'id': 'mock3',
      'userId': 'kindred_soul',
      'message': 'Anyone else journaling outside? The sky feels like a warm blanket today.',
      'timestamp': '2025-01-05T18:25:00Z'
    },
  ];
}
