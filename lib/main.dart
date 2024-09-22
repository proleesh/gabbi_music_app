import 'package:flutter/material.dart';
import 'package:gabbi_music_app/screens/register_page_screen.dart';
import 'screens/song_list_screen.dart'; // RegisterPage 추가

/**
 * author: Sung-Hyuk Lee
 * date: 2024.9.22
 */
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song and MV List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(), // MainMenu로 변경
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gabbi Main')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('노래 목록 보기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SongListScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('회원가입'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
