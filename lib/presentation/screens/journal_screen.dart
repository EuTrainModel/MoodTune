import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/journal_provider.dart';
import '../../domain/entities/mood_entry.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Could not load entries.\nPlease try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                "No mood entries yet.\nLog how you feel on the Mood tab!",
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _JournalEntryCard(entry: entry);
            },
          );
        },
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final MoodEntry entry;

  const _JournalEntryCard({required this.entry});

  IconData _iconForMood(String moodCode) {
    switch (moodCode) {
      case 'HAPPY':
        return Icons.sentiment_satisfied;
      case 'SAD':
        return Icons.sentiment_dissatisfied;
      case 'ANGRY':
        return Icons.mood_bad;
      case 'CALM':
        return Icons.self_improvement;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _labelForMood(String moodCode) {
    switch (moodCode) {
      case 'HAPPY':
        return 'Happy';
      case 'SAD':
        return 'Sad';
      case 'ANGRY':
        return 'Angry';
      case 'CALM':
        return 'Calm';
      default:
        return moodCode;
    }
  }

  String _formatDate(int millis) {
    final dt =
        DateTime.fromMillisecondsSinceEpoch(millis).toLocal();
    final two = (int n) => n.toString().padLeft(2, '0');
    return "${dt.year}-${two(dt.month)}-${two(dt.day)} "
        "${two(dt.hour)}:${two(dt.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final moodLabel = _labelForMood(entry.moodCode);
    final dateText = _formatDate(entry.createdAt);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          _iconForMood(entry.moodCode),
          size: 32,
        ),
        title: Text(
          "$moodLabel (${entry.intensity}/5)",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.note != null && entry.note!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(entry.note!),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                dateText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
