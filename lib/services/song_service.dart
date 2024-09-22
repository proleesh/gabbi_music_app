import 'dart:convert';

import 'package:gabbi_music_app/models/song.dart';
import 'package:http/http.dart' as http;

/**
 * author: Sung-Hyuk Lee
 * date: 2024.9.22
 */
class SongService {
  final String baseUrl = 'http://localhost:8080/api/songs';

  Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('음악을 불러오지를 못했습니다.');
    }
  }
}
