import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/journal_provider.dart';
import '../providers/stats_provider.dart';

import '../../domain/entities/mood_entry.dart';
import '../providers/mood_entry_provider.dart';
import '../providers/recommendations_provider.dart';
import 'recommendations_screen.dart';

class HomeMoodEntryScreen extends ConsumerStatefulWidget {
  const HomeMoodEntryScreen({super.key});

  @override
  ConsumerState<HomeMoodEntryScreen> createState() =>
      _HomeMoodEntryScreenState();
}

class _HomeMoodEntryScreenState extends ConsumerState<HomeMoodEntryScreen> {
  String _selectedMoodCode = 'HAPPY';
  int _intensity = 3;
  final TextEditingController _noteController = TextEditingController();

  final List<_MoodOption> _moods = const [
    _MoodOption(code: 'HAPPY', label: 'Happy', icon: Icons.sentiment_satisfied),
    _MoodOption(code: 'SAD', label: 'Sad', icon: Icons.sentiment_dissatisfied),
    _MoodOption(code: 'ANGRY', label: 'Angry', icon: Icons.mood_bad),
    _MoodOption(code: 'CALM', label: 'Calm', icon: Icons.self_improvement),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onGetMusicPressed() async {
    final moodEntry = MoodEntry(
      moodCode: _selectedMoodCode,
      intensity: _intensity,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      tags: null,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    // 1) Save mood
    await ref.read(moodEntryProvider.notifier).saveMood(moodEntry);

    final saveState = ref.read(moodEntryProvider);
    if (saveState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving mood: ${saveState.error}')),
      );
      return;
    }

    // ✅ Refresh Journal & Stats so they show the new entry
    ref.invalidate(journalEntriesProvider);
    ref.invalidate(moodStatsProvider);

    // 2) Get recommendations
    await ref
        .read(recommendationsProvider.notifier)
        .getRecommendations(moodEntry);
    _noteController.clear();

    // 3) Navigate
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(moodEntryProvider);
    final isSaving = saveState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('How are you feeling?')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: _moods.map((m) {
                final isSelected = m.code == _selectedMoodCode;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(m.icon, size: 18),
                      const SizedBox(width: 4),
                      Text(m.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _selectedMoodCode = m.code;
                  }),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Text(
              'Intensity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text('Low'),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: _intensity.toDouble(),
                    label: '$_intensity',
                    onChanged: (v) => setState(() {
                      _intensity = v.round();
                    }),
                  ),
                ),
                const Text('High'),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Notes (optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'e.g. tired after school...',
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _onGetMusicPressed,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.music_note),
                label: Text(isSaving ? 'Saving...' : 'Get Music'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodOption {
  final String code;
  final String label;
  final IconData icon;

  const _MoodOption({
    required this.code,
    required this.label,
    required this.icon,
  });
}
