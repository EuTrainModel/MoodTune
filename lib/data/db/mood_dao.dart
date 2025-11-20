import 'app_database.dart';
import '../../domain/entities/mood_entry.dart';

class MoodDao {
  Future<int> insertMoodEntry(MoodEntry entry) async {
    final db = await AppDatabase.instance.database;
    return db.insert('mood_entries', entry.toJson());
  }

  Future<List<MoodEntry>> getAllEntries() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'mood_entries',
      orderBy: 'createdAt DESC', // 👈 match column name in table
    );
    return result.map((e) => MoodEntry.fromJson(e)).toList();
  }

  Future<Map<String, int>> getMoodCounts() async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery('''
      SELECT moodCode, COUNT(*) as count
      FROM mood_entries
      GROUP BY moodCode
    ''');

    return {
      for (var row in result) row['moodCode'] as String: row['count'] as int,
    };
  }

  Future<int> deleteAllEntries() async {
    final db = await AppDatabase.instance.database;
    return db.delete('mood_entries'); // ลบทุก row ในตาราง
  }
}
