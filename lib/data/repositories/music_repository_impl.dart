import '../../domain/entities/track.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/music_repository.dart';
import '../api/itunes_api_client.dart';
import '../../core/mood_keywords.dart';

class MusicRepositoryImpl implements MusicRepository {
  final ItunesApiClient apiClient;

  MusicRepositoryImpl(this.apiClient);

  @override
  Future<List<Track>> getRecommendations(MoodEntry entry) async {
    final keywords = MoodKeywords.getKeywords(entry.moodCode, entry.intensity);
    return apiClient.searchTracks(keywords);
  }
}
