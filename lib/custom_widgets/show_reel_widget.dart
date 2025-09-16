import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/models/cinematography_modals.dart';
import 'package:video_player/video_player.dart';

import 'cutome_video_player_widget.dart';

class ShowReelWidget extends StatefulWidget {
  final List<WorkDataModel> films;
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
    final path = "assets/videos/showreel.mp4";
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
        bool isWide = maxWidth > 700;
        double leftRight = isWide ? maxWidth*0.15 :20;
        return Padding(
          padding: EdgeInsets.only(left: leftRight,right: leftRight),
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
                  return CustomVideoGridItem(controller: controller);
                },
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // so it won't scroll inside parent
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 5 :1,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWide ? 2 / 3 : 16/11,
                ),
                itemCount: widget.films.length,
                itemBuilder: (context, index) {
                  final film = widget.films[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onCardTap(film.category);
                        },
                        child: ClipRRect(
                          child: AspectRatio(
                            aspectRatio: 16/9, // keeps proper ratio
                            child: Image.network(
                              film.poster,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.error),
                            ),
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
                },
              )
            ],
          ),
        );
      },
    );
  }

}

