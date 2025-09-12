import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/models/cinematograpghy_modals.dart';
import 'package:video_player/video_player.dart';

class ShowReelWidget extends StatefulWidget {
  final List<FeaturedWork> films;
  final void Function(String category) onCardTap;

  const  ShowReelWidget({
    super.key,
    required this.films,
    required this.onCardTap
  });

  @override
  State<ShowReelWidget> createState() => _ShowReelWidgetState();
}

class _ShowReelWidgetState extends State<ShowReelWidget> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    final path = "assets/videos/priceless_smile06.mp4";
    _controller =  VideoPlayerController.asset(path)
        ..initialize().then((_) {
          setState(() {});
        });
    _controller.setLooping(true);
    _controller.setVolume(0);
    _controller.play();
  }

  @override
  void dispose() {
      _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        bool isWide = maxWidth > 600;
        double leftRight = isWide ? maxWidth*0.15 :20;
        return Padding(
          padding: EdgeInsets.only(left: leftRight,right: leftRight,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  final controller = _controller;
                  return VideoGridItem(controller: controller);
                },
              ),
              const SizedBox(height: 20),
              if(isWide)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.films.map((film) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:(){
                            widget.onCardTap(film.category);
                          },
                          child: ClipRRect(
                            child: Image.network(
                              film.poster,
                              fit: BoxFit.cover,
                              height: maxWidth*0.17,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          film.category,
                          style: GoogleFonts.akatab(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }).toList(),
                )


          else
              for(int i=0;i<widget.films.length;i++)
              Column(
                children: [
                  GestureDetector(
                     onTap:(){
                    widget.onCardTap(widget.films[i].category);
          },
                    child: ClipRRect(
                      child: Image.network(
                        widget.films[i].poster,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.films[i].category,style: GoogleFonts.akatab(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
                  const SizedBox(height: 14)
                ],
              )
            ],
          ),
        );
      },
    );
  }

}

/// Separate StatefulWidget for each video item
class VideoGridItem extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoGridItem({required this.controller});

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
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
    widget.controller.setVolume(10);
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

