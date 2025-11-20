// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodEntry _$MoodEntryFromJson(Map<String, dynamic> json) => MoodEntry(
  id: (json['id'] as num?)?.toInt(),
  moodCode: json['moodCode'] as String,
  intensity: (json['intensity'] as num).toInt(),
  note: json['note'] as String?,
  tags: json['tags'] as String?,
  createdAt: (json['createdAt'] as num).toInt(),
);

Map<String, dynamic> _$MoodEntryToJson(MoodEntry instance) => <String, dynamic>{
  'id': instance.id,
  'moodCode': instance.moodCode,
  'intensity': instance.intensity,
  'note': instance.note,
  'tags': instance.tags,
  'createdAt': instance.createdAt,
};
