import 'package:flutter/material.dart';
import 'package:gabbi_music_app/screens/mv_player_screen.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late Future<List<Song>> _songs;
  final SongService _songService = SongService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _songs = _songService.fetchSongs();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('재생 오류: $e')),
      );
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
  }

  void _playMv(String mvUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MVPlayerScreen(mvUrl: mvUrl),
      ),
    );
  }

  void _showSongDetails(Song song) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gabbi Music'),
      ),
      body: FutureBuilder<List<Song>>(
        future: _songs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          }
          final songs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist),
                onTap: () {
                  _showSongDetails(song);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _playAudio(song.audioUrl);
                      },
                    ),
                    if (song.mv != null)
                      IconButton(
                        icon: Icon(Icons.play_circle_fill),
                        onPressed: () {
                          _playMv(song.mv!.mvUrl);
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
