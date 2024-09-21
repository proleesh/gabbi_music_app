import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/song_service.dart';
import 'mv_player_screen.dart';

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late Future<List<Song>> _songsFuture;
  final SongService _songService = SongService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Song> songs = [];
  Song? _currentSong;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _songsFuture = _songService.fetchSongs();

    // Listen for duration changes
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    // Listen for position updates
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    // Listen for player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _position = Duration.zero;
          _currentSong?.isPlaying = false;
          _currentSong = null;
          _isPaused = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(Song song) async {
    try {
      if (_isPaused && _currentSong == song) {
        // 곡이 일시정지 상태일 경우 재개
        _resumeAudio();
      } else {
        // 새로운 곡을 재생할 때만 URL을 설정
        await _audioPlayer.setUrl(song.audioUrl);
        await _audioPlayer.play();
        setState(() {
          _isPaused = false;
          _currentSong?.isPlaying = false; // 이전 노래 재생 종료
          _currentSong = song;
          _currentSong?.isPlaying = true; // 현재 노래 재생 시작
          for (var s in songs) {
            s.isPlaying = s == song;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('재생 오류: $e')),
      );
    }
  }

  void _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _isPaused = true; // 일시정지 상태 설정
        _currentSong?.isPlaying = false;
      });
    } catch (e) {
      print('음악 일시정지 오류: $e');
    }
  }

  void _resumeAudio() async {
    try {
      await _audioPlayer.play();
      setState(() {
        _isPaused = false; // 재개 상태로 변경
        _currentSong?.isPlaying = true;
      });
    } catch (e) {
      print('재개 오류: $e');
    }
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gabbi Music'),
      ),
      body: FutureBuilder<List<Song>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          }
          songs = snapshot.data ?? [];

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                title: Text(song.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.artist),
                    if (_currentSong == song &&
                        song.isPlaying &&
                        _duration > Duration.zero)
                      Column(
                        children: [
                          Slider(
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              _audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(_position)),
                              Text(_formatDuration(_duration)),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        (song.isPlaying) ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (song.isPlaying) {
                          _pauseAudio();
                        } else {
                          _playAudio(song);
                        }
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
