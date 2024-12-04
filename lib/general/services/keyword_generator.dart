List<String> generateKeywords(String text) {
  List<String> keywords = [];
  final words = text.toLowerCase().split(" ");

  // Generate all substrings for each word
  for (var word in words) {
    for (int i = 0; i < word.length; i++) {
      for (int j = i + 1; j <= word.length; j++) {
        keywords.add(word.substring(i, j));
      }
    }
  }

  // Generate combinations of multiple words
  for (int i = 0; i < words.length; i++) {
    String combined = words[i];
    for (int j = i + 1; j < words.length; j++) {
      combined += " ${words[j]}";
      final combinedWords = combined.replaceAll(" ", "");
      for (int k = 0; k < combinedWords.length; k++) {
        for (int l = k + 1; l <= combinedWords.length; l++) {
          keywords.add(combinedWords.substring(k, l));
        }
      }
    }
  }

  return keywords.toSet().toList(); // Remove duplicates by converting to a Set
}
