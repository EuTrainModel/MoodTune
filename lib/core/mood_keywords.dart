class MoodKeywords {
  static String getKeywords(String moodCode, int intensity) {
    switch (moodCode) {
      case "HAPPY":
        return intensity >= 4
            ? "happy upbeat energetic pop"
            : "soft happy chill pop";
      case "SAD":
        return intensity >= 4
            ? "sad emotional piano"
            : "soft sad acoustic";
      case "ANGRY":
        return intensity >= 4
            ? "angry metal heavy rock"
            : "aggressive hip-hop beats";
      case "CALM":
        return "calm relaxing ambient lo-fi";
      default:
        return "mood music chill";
    }
  }
}
