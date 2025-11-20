import '../entities/track.dart';
import '../entities/mood_entry.dart';

abstract class MusicRepository {
  Future<List<Track>> getRecommendations(MoodEntry entry);
}
