import 'dart:convert';

import 'package:gabbi_music_app/models/mv.dart';
import 'package:http/http.dart' as http;

class MVService {
  final String baseUrl = 'http://localhost:8080/api/mvs';

  Future<List<MV>> fetchMVs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => MV.fromJson(json)).toList();
    } else {
      throw Exception('뮤비를 불러오지를 못했습니다.');
    }
  }
}
