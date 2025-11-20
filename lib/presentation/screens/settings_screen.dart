import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/journal_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/mood_entry_provider.dart'; // for moodDaoProvider

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Clear app data',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Delete all mood history stored on this device.',
              ),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear app data?'),
                    content: const Text(
                      'This will delete all mood entries from your journal '
                      'and stats. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed != true) return;

                // 1) Delete all entries from DB
                final moodDao = ref.read(moodDaoProvider);
                await moodDao.deleteAllEntries();

                // 2) Refresh journal & stats providers
                ref.invalidate(journalEntriesProvider);
                ref.invalidate(moodStatsProvider);

                // 3) Notify user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All mood data has been cleared.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
