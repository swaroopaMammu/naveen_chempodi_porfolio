import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/models/cinematograpghy_modals.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AssociatedDetailScreen extends StatefulWidget {
  final FeaturedWork film;
  final String designation;
  const AssociatedDetailScreen({super.key,required this.film,required this.designation});

  @override
  State<AssociatedDetailScreen> createState() => _AssociatedDetailScreenState();
}

class _AssociatedDetailScreenState extends State<AssociatedDetailScreen> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: widget.film.trailerId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem("Producer", widget.film.credit.production),
        _buildDetailItem("Director", widget.film.credit.director),
        _buildDetailItem("Client", "ABC Studios"),
        _buildDetailItem(widget.designation, "Naveen Chempodi" ),
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
          bool isWide = constraints.maxWidth > 700;
          return
            Padding(
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
                      controller: _youtubeController,
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
                    controller: _youtubeController,
                    // showVideoProgressIndicator: true,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetails(),
              ],
            ),
          );
        },
      );
  }
}
