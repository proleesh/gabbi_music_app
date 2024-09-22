import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gabbi_music_app/models/mv.dart';

/**
 * author: Sung-Hyuk Lee
 * date: 2024.9.22
 */
class MVService {
  final String baseUrl = 'http://localhost:8080/api/mvs'; // 서버 URL

  // ID로 특정 MV 데이터를 가져오는 메서드
  Future<MV> fetchMVById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});

    if (response.statusCode == 200) {
      return MV.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('MV를 불러오지 못했습니다.');
    }
  }
}
