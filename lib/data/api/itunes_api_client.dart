import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/track.dart';

class ItunesApiClient {
  final http.Client client = http.Client();

  Future<List<Track>> searchTracks(String term) async {
    final uri = Uri.https('itunes.apple.com', '/search', {
      'term': term,
      'media': 'music',
      'limit': '20',
    });

    final response = await client.get(uri);
    final jsonData = json.decode(response.body);

    final results = jsonData['results'] as List<dynamic>? ?? [];

    return results.map((e) {
      return Track(
        trackId: (e['trackId'] ?? '').toString(),
        title: e['trackName'] ?? '',
        artist: e['artistName'] ?? '',
        artworkUrl: e['artworkUrl100'] ?? '',
        previewUrl: e['previewUrl'] ?? '',
      );
    }).toList();
  }
}
