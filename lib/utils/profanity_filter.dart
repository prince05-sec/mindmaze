class ProfanityFilter {
  static final List<String> bannedWords = [
    "badword1",
    "badword2",
    "badword3",
    // extend this list
  ];

  static bool containsProfanity(String text) {
    for (final word in bannedWords) {
      if (text.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }
}
