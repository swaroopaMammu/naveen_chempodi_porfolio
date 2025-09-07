import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget extends StatefulWidget {
  final String assetPath;

  const VideoPlayerWidget({Key? key, required this.assetPath}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isReady = false;
  bool showOverlay = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() => _isReady = true);
      });
  }

  void setButton(){
    if (_controller.value.isPlaying) {
      _controller.pause();
      showOverlay = true;
    } else {
      _controller.play();
      showOverlay = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: (){
        setState(() {
          setButton();
        });
      },
      child: ClipRRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            if(showOverlay)
            IconButton(
              iconSize: 48,
              color: Colors.white,
              icon: Icon(
                Icons.play_circle_fill,
              ),
              onPressed: () {
                setState(() {
                  setButton();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
