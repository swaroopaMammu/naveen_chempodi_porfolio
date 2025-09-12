import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/custom_widgets/video_player_widget.dart';

import '../models/cinematograpghy_modals.dart';

class FeaturedWorkGrid extends StatefulWidget {
  final List<FeaturedWork> films;
  final void Function(FeaturedWork film) onTrailerTap;
  const FeaturedWorkGrid({
    super.key,
    required this.films,
    required this.onTrailerTap
  });

  @override
  State<FeaturedWorkGrid> createState() => _FeaturedWorkGridState();
}

class _FeaturedWorkGridState extends State<FeaturedWorkGrid> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        int crossAxisCount = isWide ? 3 : 1;
        double padding = isWide ? constraints.maxWidth*0.15 : 20;
        return Padding(
          padding:  EdgeInsets.only(left: padding,right: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 30,
                childAspectRatio: 16 / 12,
              ),
              itemCount: widget.films.length,
              itemBuilder: (context, index) {
                final film = widget.films[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _FeaturedWorkItem(
                        film: film,
                        onTap: () {
                          widget.onTrailerTap(film);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      film.filmName,
                      style: GoogleFonts.akatab(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(
                255, 44, 42, 42),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      film.category,
                      style: GoogleFonts.akatab(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ]
          ),
        );
      },
    );
  }

  /// FEATURE_SIDE_SHEET
  void _showFeaturedVideoSideSheet(BuildContext context, {required FeaturedWork film}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6, // 🟢 Side sheet width
            height: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                // 🔹 Main Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isSmallScreen = constraints.maxWidth < 600;
                          double bottomPadding = isSmallScreen ? 10 : 40;
                          double leftRight = isSmallScreen ? 10 : 80;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isSmallScreen
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${film.filmName} (${film.yearOfRelease})",
                                    style: GoogleFonts.alef(
                                        fontSize: 24,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFilmDetails(context, film),
                                ],
                              )
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${film.filmName} (${film.yearOfRelease})",
                                      style: GoogleFonts.alef(
                                        fontSize: 28,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFC0C0C0),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 3,
                                    child: _buildFilmDetails(context, film),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // 🔹 Video list
                              Column(
                                children: film.videoPaths.map((assetPath) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: bottomPadding,
                                      left: leftRight,
                                      right: leftRight,
                                    ),
                                    child: VideoPlayerWidget(assetPath: assetPath),
                                  );
                                }).toList(),
                              ),

                              // 🔹 Credits
                              Center(child: _buildCreditsSection(film)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 🔹 Close Button
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final offsetAnim = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(anim);
        return SlideTransition(position: offsetAnim, child: child);
      },
    );
  }

  Widget _buildFilmDetails(BuildContext context, FeaturedWork film) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size based on screen width
    double fontSize = screenWidth < 600 ? 12 : 14;
    double spacing = screenWidth < 600 ? 6 : 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type: ${film.category}",
          style: GoogleFonts.alef(fontSize: fontSize,
              color: Color(0xFFC0C0C0),
              decoration: TextDecoration.none,
              fontWeight:FontWeight.w500),
        ),
        SizedBox(height: spacing),
        Text(
          "Synopsis: ${film.description}",
          style: GoogleFonts.alef(fontSize: fontSize,
              color: Color(0xFFC0C0C0),
              decoration: TextDecoration.none,
              fontWeight:FontWeight.w500),
        ),
        SizedBox(height: spacing),
        Text(
          "Year: ${film.yearOfRelease}",
          style: GoogleFonts.alef(fontSize: fontSize,
              color: Color(0xFFC0C0C0),
              decoration: TextDecoration.none,
              fontWeight:FontWeight.w500),
        ),
        GestureDetector(
          onTap: (){
          },
          child: Text(
            "Youtube link",
            style: GoogleFonts.alef(fontSize: 10,
                decoration: TextDecoration.none,color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditsSection(FeaturedWork film) {
    final credits = <String, String>{
      "Director of Photography": "Naveen Chempodi",
      if (film.credit.screenplay.isNotEmpty) "Screenplay": film.credit.screenplay,
      if (film.credit.editor.isNotEmpty) "Editor": film.credit.editor,
      if (film.credit.di.isNotEmpty) "DI": film.credit.di,
      if (film.credit.art_director.isNotEmpty) "Art Director": film.credit.art_director,
      if (film.credit.sync_sound.isNotEmpty) "Sync Sound": film.credit.sync_sound,
      if (film.credit.production.isNotEmpty) "Production": film.credit.production,
    };
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "CREDITS",
            style: GoogleFonts.lora(
              decoration: TextDecoration.none,
              fontSize: 16, fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: credits.entries
                .map((entry) => _creditRow(context,entry.key, entry.value))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _creditRow(BuildContext context, String title, String name) {
    double screenWidth = MediaQuery.of(context).size.width;

    double fontSize = screenWidth < 600 ? 14 : 16;
    double valueFontSize = screenWidth < 600 ? 14 : 16;

    double columnWidth = screenWidth < 600 ? 120 : 200;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: columnWidth,
            child: Text(
              title,
              style:GoogleFonts.alef(fontSize: fontSize, decoration: TextDecoration.none),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: columnWidth,
            child: Text(
              name,
              style: GoogleFonts.alef(fontSize: valueFontSize, decoration: TextDecoration.none, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedWorkItem extends StatefulWidget {
  final FeaturedWork film;
  final VoidCallback onTap;

  const _FeaturedWorkItem({
    required this.film,
    required this.onTap,
  });

  @override
  State<_FeaturedWorkItem> createState() => _FeaturedWorkItemState();
}

class _FeaturedWorkItemState extends State<_FeaturedWorkItem> {
  bool isHovered = false;
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.9);
  }

  void _onTapUp(_) {
    setState((){
       _scale = 1.0;
        widget.onTap();
    });
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  widget.film.poster,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
              AnimatedOpacity(
                opacity: isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: Text(
                    widget.film.category,
                    textAlign: TextAlign.center,
                    style:  GoogleFonts.akatab(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
