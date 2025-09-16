import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/models/cinematography_modals.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'cutome_video_player_widget.dart';

class WorkDetailWidget extends StatefulWidget {
  final WorkDataModel film;
  const WorkDetailWidget({super.key,required this.film});

  @override
  State<WorkDetailWidget> createState() => _FeatureDetailedState();
}

class _FeatureDetailedState extends State<WorkDetailWidget> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller =  VideoPlayerController.asset(widget.film.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.film.director.isNotEmpty)
        _buildDetailItem("Director", widget.film.director),
        if(widget.film.client.isNotEmpty)
        _buildDetailItem("Production/Client", widget.film.client),
        _buildDetailItem(widget.film.designation, "Naveen Chempodi" ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.akatab(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.akatab(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 850;
        double videoWidth = isWide ? constraints.maxWidth * 0.6 : constraints
            .maxWidth;
        double videoHeight = videoWidth * 9 / 16; // maintain 16:9 ratio
        bool isYoutube = widget.film.videoPath.isEmpty;
        return isYoutube
            ? buildYoutubePlayer(context, isWide)
            : buildCustomVideoPlayer(context, isWide, videoWidth, videoHeight);
      },
    );
  }


  Widget buildCustomVideoPlayer(BuildContext context,bool isWide,double videoWidth,double videoHeight){
   return Padding(
      padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
      child: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: videoWidth,
            height: videoHeight,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 16 / 9,
              ),
              itemCount: 1,
              itemBuilder: (context, index) {
                final controller = _controller;
                return CustomVideoGridItem(controller: controller);
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _buildDetails(),
          ),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: videoWidth,
            height: videoHeight,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 16 / 9,
              ),
              itemCount: 1,
              itemBuilder: (context, index) {
                final controller = _controller;
                return CustomVideoGridItem(controller: controller);
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget buildYoutubePlayer(BuildContext context,bool isWide) {
    YoutubePlayerController youtubeController = YoutubePlayerController.fromVideoId(
      videoId: widget.film.trailerId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: youtubeController,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _buildDetails(),
          ),
        ],
      )
          : Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: youtubeController,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetails(),
        ],
      ),
    );
  }

}
