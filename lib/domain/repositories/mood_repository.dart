import '../entities/mood_entry.dart';

abstract class MoodRepository {
  Future<int> insertMoodEntry(MoodEntry entry);
  Future<List<MoodEntry>> getAllEntries();
  Future<Map<String, int>> getMoodCounts();
}
