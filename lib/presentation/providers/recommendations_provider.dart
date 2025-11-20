import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/music_repository.dart';
import '../../data/api/itunes_api_client.dart';
import '../../data/repositories/music_repository_impl.dart';

/// ---------------------
/// PROVIDERS
/// ---------------------

final itunesApiClientProvider = Provider((ref) => ItunesApiClient());

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  final api = ref.watch(itunesApiClientProvider);
  return MusicRepositoryImpl(api);
});

/// AsyncNotifier version
class RecommendationsController
    extends AsyncNotifier<List<Track>> {
  late final MusicRepository _repo;

  @override
  FutureOr<List<Track>> build() {
    _repo = ref.watch(musicRepositoryProvider);
    return [];
  }

  Future<void> getRecommendations(MoodEntry entry) async {
    state = const AsyncLoading();
    try {
      final tracks = await _repo.getRecommendations(entry);
      state = AsyncData(tracks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final recommendationsProvider =
    AsyncNotifierProvider<RecommendationsController, List<Track>>(() {
  return RecommendationsController();
});
