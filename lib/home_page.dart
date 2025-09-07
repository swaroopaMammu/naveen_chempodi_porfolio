import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_website/repository/cinema_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'custom_widgets/associate_widget.dart';
import 'custom_widgets/bio_widget.dart';
import 'custom_widgets/feature_widget.dart';
import 'custom_widgets/show_reel_widget.dart';
import 'custom_widgets/video_player_widget.dart';
import 'models/cinematograpghy_modals.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMenuOpen = false;
  String _selectedPage = "Showreel";
 late CinemaRepository repo;

  @override
  void initState() {
    super.initState();
    repo = CinemaRepository();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateTo(String page) {
    setState(() {
      _selectedPage = page;
      _isMenuOpen = false;
    });
  }

  Widget _buildCustomHeader() {
    final menuItems = ["Showreel", "Featured Work", "Associated Work", "Bio"];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: Colors.transparent,
          child: Row(
            children: [
              // 🔹 Name Column on the left
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPage = "Showreel";
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      "Naveen Chempodi",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      "Cinematographer",
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!isMobile)
                Row(
                  children: menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPage = item;
                          });
                        },
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedPage == item ? FontWeight.bold : FontWeight.w400,
                            color: _selectedPage == item ? Colors.black : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                IconButton(
                  icon: Icon(
                    _isMenuOpen ? Icons.close : Icons.menu,
                    size: 28,
                    color: Colors.black,
                  ),
                  onPressed: _toggleMenu,
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildCustomHeader(),

          // Main content
          Expanded(
            child: _buildMainContent(),
          ),
          // Footer
          if(_selectedPage != "Showreel")
            _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isMenuOpen) {
      return _buildMenuOverlay();
    }
    switch (_selectedPage) {
      case "Showreel":
        return ShowReelWidget(footer:  _buildFooter());
      case "Bio":
        return BioSection();
      case "Featured Work":
        {
          final  List<FeaturedWork> works = repo.getFeatureWork();
          return FeaturedWorkGrid(
            films: works,
            onTrailerTap: (film) {
              _showFeaturedVideoModal(
                context,
                film: film,
              );
            },
          );
        }
      case "Associated Work":
          return AssoWorkSection(
      onCategoryChanged: (trailerId) {
        _showYoutubeModal(context, trailerId);
      },
    );
      default:
        return _buildPlaceholderPage(_selectedPage);
    }
  }

  Widget _buildMenuOverlay() {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.95),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _menuItem("Showreel"),
          _menuItem("Featured Work"),
          _menuItem("Associated Work"),
          _menuItem("Bio"),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _menuItem(String text) {
    return GestureDetector(
      onTap: () => _navigateTo(text),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style:  GoogleFonts.lora(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  void _showYoutubeModal(BuildContext context, String videoId) {
    final YoutubePlayerController controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54, // semi-transparent background
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(30),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () {
                  controller.stopVideo();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeaturedVideoModal(BuildContext context, {required FeaturedWork film}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth * 0.9;
            double maxHeight = constraints.maxHeight * 0.9;
            bool isSmallScreen = constraints.maxWidth < 600;
            double bottomPadding = constraints.maxWidth < 600 ? 10 : 40;

            return Center(
              child: Stack(
                children: [
                  // 🔹 Main Content
                  Container(
                    width: maxWidth,
                    height: maxHeight,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          isSmallScreen
                              ? Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${film.filmName} (${film.yearOfRelease})",
                                  style: GoogleFonts.lora(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildFilmDetails(context, film),
                              ],
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${film.filmName} (${film.yearOfRelease})",
                                    style: GoogleFonts.lora(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
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
                          ),
                          const SizedBox(height: 30),
                          Column(
                            children: film.videoPaths.map((assetPath) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: bottomPadding),
                                child: VideoPlayerWidget(assetPath: assetPath),
                              );
                            }).toList(),
                          ),
                          Center(child: _buildCreditsSection(film)),
                        ],
                      ),
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
            );
          },
        ),
      ),
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
          style: GoogleFonts.lora(fontSize: fontSize,fontWeight:FontWeight.w500),
        ),
        SizedBox(height: spacing),
        Text(
          "Synopsis: ${film.description}",
          style: GoogleFonts.lora(fontSize: fontSize,fontWeight:FontWeight.w500),
        ),
        SizedBox(height: spacing),
        Text(
          "Year: ${film.yearOfRelease}",
          style: GoogleFonts.lora(fontSize: fontSize,fontWeight:FontWeight.w500),
        ),
        GestureDetector(
          onTap: (){
            _showYoutubeModal(context, film.trailerId);
          },
          child: Text(
            "Youtube link",
            style: GoogleFonts.lora(fontSize: 10, color: Colors.blue),
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
              style:GoogleFonts.lora(fontSize: fontSize),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: columnWidth,
            child: Text(
              name,
              style: GoogleFonts.lora(fontSize: valueFontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }


  /// PLACEHOLDER
  Widget _buildPlaceholderPage(String page) {
    return Center(
      child: Text(
        "$page Page (Coming Soon)",
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }

  Widget _buildFooter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.transparent,
         child: Column(
            children: [const SizedBox(height: 10), _footerIcons(),const SizedBox(height: 20),_footerText() ],
          ),
        );
      },
    );
  }

  Widget _footerText() => const Text(
    "© 2025 Naveen Chempodi. All right reserved.",
    style: TextStyle(fontSize: 13, color: Colors.grey, letterSpacing: 0.5),
  );

  Widget _footerIcons() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialIcon(FontAwesomeIcons.instagram, "https://www.instagram.com/naveenchempodi?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.linkedin, "https://www.linkedin.com/in/naveen-chempodi-5482a224a/"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.imdb, "https://www.imdb.com/name/nm11117697/?ref_=nv_sr_srsg_0_tt_0_nm_1_in_0_q_naveen%2520chempodi"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.link, "https://linktr.ee/naveen_chempodi?utm_source=linktree_profile_share"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.facebook, "https://..."),
    ],
  );

  /// Helper widget for social icons
  Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception("Could not launch $uri");
        }
      },
      child: FaIcon(icon, size: 18, color: Colors.grey),
    );
  }

}
