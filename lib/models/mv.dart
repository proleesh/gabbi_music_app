/**
 * author: Sung-Hyuk Lee
 * date: 2024.9.22
 */
class MV {
  final int id;
  final String mvUrl;

  MV({required this.id, required this.mvUrl});

  factory MV.fromJson(Map<String, dynamic> json) {
    return MV(
      id: json['id'],
      mvUrl: json['mvUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mvUrl': mvUrl,
    };
  }
}
