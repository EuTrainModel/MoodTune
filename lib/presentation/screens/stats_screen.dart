import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/stats_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Stats'),
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Could not load stats.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (moodCounts) {
          if (moodCounts.isEmpty) {
            return const Center(
              child: Text(
                'No mood data yet.\nLog some moods first!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final total = moodCounts.values.fold<int>(0, (a, b) => a + b);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Mood distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Pie chart
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: _buildSections(moodCounts, total),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Legend + percentages
                Expanded(
                  child: ListView(
                    children: moodCounts.entries.map((entry) {
                      final moodCode = entry.key;
                      final count = entry.value;
                      final percent = (count / total * 100).toStringAsFixed(1);

                      final moodInfo = _moodInfoForCode(moodCode);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: moodInfo.color.withOpacity(0.2),
                          child: Icon(
                            moodInfo.icon,
                            color: moodInfo.color,
                          ),
                        ),
                        title: Text('${moodInfo.label}'),
                        subtitle: Text('$count entries  •  $percent%'),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      Map<String, int> moodCounts, int total) {
    final List<PieChartSectionData> sections = [];
    moodCounts.forEach((moodCode, count) {
      final moodInfo = _moodInfoForCode(moodCode);
      final value = count.toDouble();
      final percent = total == 0 ? 0 : (value / total * 100);

      sections.add(
        PieChartSectionData(
          value: value,
          title: '${percent.toStringAsFixed(0)}%',
          radius: 70,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          color: moodInfo.color,
        ),
      );
    });
    return sections;
  }

  _MoodInfo _moodInfoForCode(String moodCode) {
    switch (moodCode) {
      case 'HAPPY':
        return _MoodInfo(
          label: 'Happy',
          color: Colors.orange,
          icon: Icons.sentiment_satisfied,
        );
      case 'SAD':
        return _MoodInfo(
          label: 'Sad',
          color: Colors.blue,
          icon: Icons.sentiment_dissatisfied,
        );
      case 'ANGRY':
        return _MoodInfo(
          label: 'Angry',
          color: Colors.red,
          icon: Icons.mood_bad,
        );
      case 'CALM':
        return _MoodInfo(
          label: 'Calm',
          color: Colors.green,
          icon: Icons.self_improvement,
        );
      default:
        return _MoodInfo(
          label: moodCode,
          color: Colors.grey,
          icon: Icons.sentiment_neutral,
        );
    }
  }
}

class _MoodInfo {
  final String label;
  final Color color;
  final IconData icon;

  const _MoodInfo({
    required this.label,
    required this.color,
    required this.icon,
  });
}
