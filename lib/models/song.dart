import 'mv.dart';

/**
 * author: Sung-Hyuk Lee
 * date: 2024.9.22
 */
class Song {
  final int id;
  final String title;
  final String artist;
  final String audioUrl;
  bool isPlaying;
  final MV? mv;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    this.isPlaying = false,
    this.mv,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      audioUrl: json['audioUrl'],
      isPlaying: json['isPlaying'] ?? false,
      mv: json['mv'] != null ? MV.fromJson(json['mv']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'isPlaying': isPlaying,
      if (mv != null) 'mv': mv!.toJson(),
    };
  }
}
