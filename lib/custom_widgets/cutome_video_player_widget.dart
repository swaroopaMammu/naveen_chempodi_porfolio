import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoGridItem extends StatefulWidget {
  final VideoPlayerController controller;

  const CustomVideoGridItem({super.key, required this.controller});

  @override
  State<CustomVideoGridItem> createState() => _CustomVideoGridItemState();
}

class _CustomVideoGridItemState extends State<CustomVideoGridItem> {
  bool showOverlay = true;

  void setButton() {
    if (widget.controller.value.isPlaying && showOverlay) {
      showOverlay = false;
    } else if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      showOverlay = true;
    } else {
      widget.controller.play();
      showOverlay = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return
      Builder(
          builder: (context) {
            return GestureDetector(
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
      );
  }
}