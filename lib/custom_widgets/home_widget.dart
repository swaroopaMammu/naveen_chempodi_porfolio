import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeContentGrid extends StatefulWidget {
  final Widget footer;

  const HomeContentGrid({
    super.key,
    required this.footer,
  });

  @override
  State<HomeContentGrid> createState() => _HomeContentGridState();
}

class _HomeContentGridState extends State<HomeContentGrid> {
  late List<VideoPlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    final videos = [
      "assets/images/football.mp4",
      "assets/images/video1.mp4",
      "assets/images/video2.mp4",
      "assets/images/video3.mp4",
      "assets/images/video4.mp4",
      "assets/images/video5.mp4",
    ];
    _controllers = videos.map((path) {
      final controller =  VideoPlayerController.asset(path)
        ..initialize().then((_) {
          setState(() {});
        });
      controller.setLooping(true);
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for( var controller in _controllers){
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int crossAxisCount = maxWidth < 600 ? 1 : 2;

        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Cinematography Showreel",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 40,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  final controller = _controllers[index];
                  return _VideoGridItem(controller: controller);
                },
              ),
            ),
            const SizedBox(height: 40),
            widget.footer,
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

/// Separate StatefulWidget for each video item
class _VideoGridItem extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoGridItem({required this.controller});

  @override
  State<_VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<_VideoGridItem> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return controller.value.isInitialized
        ? Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),
        ),
        IconButton(
          iconSize: 48,
          color: Colors.white,
          icon: Icon(
            controller.value.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_fill,
          ),
          onPressed: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
        ),
      ],
    )
        : const Center(child: CircularProgressIndicator());
  }
}
