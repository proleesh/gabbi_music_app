import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MVPlayerScreen extends StatefulWidget {
  final String mvUrl;

  MVPlayerScreen({required this.mvUrl});

  @override
  _MVPlayerScreenState createState() => _MVPlayerScreenState();
}

class _MVPlayerScreenState extends State<MVPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    print('Playing video from URL: ${widget.mvUrl}');

    try {
      _controller = VideoPlayerController.network(widget.mvUrl);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
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
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('비디오를 로드하는 중 오류가 발생했습니다.'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
