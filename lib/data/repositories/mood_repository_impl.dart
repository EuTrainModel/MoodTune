import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';
import '../db/mood_dao.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodDao dao;

  MoodRepositoryImpl(this.dao);

  @override
  Future<int> insertMoodEntry(MoodEntry entry) {
    return dao.insertMoodEntry(entry);
  }

  @override
  Future<List<MoodEntry>> getAllEntries() {
    return dao.getAllEntries();
  }

  @override
  Future<Map<String, int>> getMoodCounts() {
    return dao.getMoodCounts();
  }
}
