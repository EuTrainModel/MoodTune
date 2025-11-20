import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/mood_repository.dart';
import '../providers/mood_entry_provider.dart';

/// Provides a map of moodCode -> count from the database
final moodStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getMoodCounts();
});
