import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/custom_widgets/show_reel_widget.dart';
import 'package:portfolio_website/models/cinematograpghy_modals.dart';
import 'package:video_player/video_player.dart';

class FeatureDetailedWidget extends StatefulWidget {
  final FeaturedWork film;
  final String designation;
  const FeatureDetailedWidget({super.key,required this.film,required this.designation});

  @override
  State<FeatureDetailedWidget> createState() => _FeatureDetailedState();
}

class _FeatureDetailedState extends State<FeatureDetailedWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =  VideoPlayerController.asset(widget.film.videoPaths[0])
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
        bool isWide = constraints.maxWidth > 600;
        double videoWidth = isWide ? constraints.maxWidth * 0.6 : constraints.maxWidth;
        double videoHeight = videoWidth * 9 / 16; // maintain 16:9 ratio

        return Padding(
          padding: const EdgeInsets.all(16.0),
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
                    return VideoGridItem(controller: controller);
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
                    return VideoGridItem(controller: controller);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildDetails(),
            ],
          ),
        );
      },
    );
  }

}
