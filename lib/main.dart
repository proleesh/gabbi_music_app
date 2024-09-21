import 'package:flutter/material.dart';
import 'screens/song_list_screen.dart';

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
      home: SongListScreen(),
    );
  }
}
