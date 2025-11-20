import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';
import '../../data/db/mood_dao.dart';
import '../../data/repositories/mood_repository_impl.dart';

/// ------------------
/// PROVIDERS
/// ------------------

final moodDaoProvider = Provider((ref) => MoodDao());

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final dao = ref.watch(moodDaoProvider);
  return MoodRepositoryImpl(dao);
});

/// AsyncNotifier version
class MoodEntryController extends AsyncNotifier<void> {
  late final MoodRepository _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.watch(moodRepositoryProvider);
  }

  Future<void> saveMood(MoodEntry entry) async {
    state = const AsyncLoading();
    try {
      await _repo.insertMoodEntry(entry);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final moodEntryProvider =
    AsyncNotifierProvider<MoodEntryController, void>(() {
  return MoodEntryController();
});
