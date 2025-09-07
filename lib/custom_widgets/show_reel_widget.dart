import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ShowReelWidget extends StatefulWidget {
  final Widget footer;

  const ShowReelWidget({
    super.key,
    required this.footer,
  });

  @override
  State<ShowReelWidget> createState() => _ShowReelWidgetState();
}

class _ShowReelWidgetState extends State<ShowReelWidget> {
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
      controller.setVolume(0);
      controller.play();
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
        double fontSize = maxWidth < 600 ? 24 : 34;
        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
             Center(
              child: Text(
                "Cinematography Showreel",
                style: GoogleFonts.lora(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:  EdgeInsets.all(0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
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
  bool showOverlay = true;

  void setButton(){
    if (widget.controller.value.isPlaying && showOverlay) {
      showOverlay = false;
    }
    else if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      showOverlay = true;
    } else {
      widget.controller.play();
      showOverlay = false;
    }
    widget.controller.setVolume(10);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return
      GestureDetector(
      onTap: (){
        setState(() {
          setButton();
        });
      },
          child: Stack(
                alignment: Alignment.center,
                children: [
          ClipRRect(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child:controller.value.isInitialized
                      ? VideoPlayer(controller)
                      : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
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
          if (showOverlay)
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
        );
  }
}
