import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:gabbi_music_app/services/mv_service.dart'; // MVService import
import 'package:gabbi_music_app/models/mv.dart'; // MV 모델 import

class MVPlayerScreen extends StatefulWidget {
  final int mvId; // MV의 ID를 받아와서 해당 MV URL을 가져옴

  MVPlayerScreen({required this.mvId});

  @override
  _MVPlayerScreenState createState() => _MVPlayerScreenState();
}

class _MVPlayerScreenState extends State<MVPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final MVService _mvService = MVService(); // MVService 인스턴스
  String? mvUrl; // 비디오 URL 저장 변수

  @override
  void initState() {
    super.initState();
    _fetchMvUrl(widget.mvId); // MV URL을 가져옴
  }

  // 서버에서 MV URL을 가져오는 메서드
  void _fetchMvUrl(int mvId) async {
    try {
      MV mv = await _mvService.fetchMVById(mvId); // MV ID를 통해 MV 데이터를 가져옴
      String baseUrl = "http://localhost:8080"; // 서버의 도메인 또는 IP 주소
      String fullMvUrl = "$baseUrl${mv.mvUrl}";

      print("Fetched MV URL : $fullMvUrl");

      setState(() {
        mvUrl = fullMvUrl; // 절대 URL로 설정
      });

      _initializeVideoPlayer(fullMvUrl); // 절대 URL을 사용해 비디오 재생
    } catch (e) {
      print('MV 데이터를 불러오는 중 오류 발생: $e');
    }
  }

  // 비디오 플레이어 초기화
  void _initializeVideoPlayer(String url) {
    try {
      final encodedUrl = Uri.encodeFull(url); // mvUrl을 인코딩
      _controller = VideoPlayerController.network(encodedUrl);
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        setState(() {
          print("비디오 초기화 성공, 재생 시작: $url");
          _controller.setLooping(true);
          _controller.play();
        });
      }).catchError((error) {
        print("비디오 초기화 실패: $error");
      });
    } catch (e) {
      print('비디오 초기화 중 오류 발생: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gabbi Watch'),
      ),
      body: mvUrl == null
          ? Center(child: CircularProgressIndicator()) // MV URL이 없으면 로딩 표시
          : FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else if (snapshot.hasError) {
                  print('비디오 로드 중 오류: ${snapshot.error}');
                  return Center(child: Text('비디오를 로드하는 중 오류가 발생했습니다.'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: mvUrl != null && _controller.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
