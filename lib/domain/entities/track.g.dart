// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
  trackId: json['trackId'] as String,
  title: json['title'] as String,
  artist: json['artist'] as String,
  artworkUrl: json['artworkUrl'] as String,
  previewUrl: json['previewUrl'] as String,
);

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
  'trackId': instance.trackId,
  'title': instance.title,
  'artist': instance.artist,
  'artworkUrl': instance.artworkUrl,
  'previewUrl': instance.previewUrl,
};
