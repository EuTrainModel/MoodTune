import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mood_entry.dart';
import 'mood_entry_provider.dart'; // for moodRepositoryProvider

final journalEntriesProvider =
    FutureProvider<List<MoodEntry>>((ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getAllEntries();
});
