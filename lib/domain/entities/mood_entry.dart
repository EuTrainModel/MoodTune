import 'package:json_annotation/json_annotation.dart';

part 'mood_entry.g.dart';

@JsonSerializable()
class MoodEntry {
  final int? id;
  final String moodCode;
  final int intensity;
  final String? note;
  final String? tags;
  final int createdAt;

  MoodEntry({
    this.id,
    required this.moodCode,
    required this.intensity,
    this.note,
    this.tags,
    required this.createdAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) =>
      _$MoodEntryFromJson(json);
  Map<String, dynamic> toJson() => _$MoodEntryToJson(this);
}
