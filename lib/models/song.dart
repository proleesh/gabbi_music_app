import 'mv.dart';

class Song {
  final int id;
  final String title;
  final String artist;
  final String audioUrl;
  final MV? mv;

  Song(
      {required this.id,
      required this.title,
      required this.artist,
      required this.audioUrl,
      required this.mv});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      audioUrl: json['audioUrl'],
      mv: json['mv'] != null ? MV.fromJson(json['mv']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      if (mv != null) 'mv': mv!.toJson(),
    };
  }
}
