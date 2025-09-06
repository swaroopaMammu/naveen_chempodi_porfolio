import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_website/repository/cinema_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'models/cinematograpghy_modals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMenuOpen = false;
  String _selectedPage = "ShowReel";
 late CinemaRepository repo;

  late YoutubePlayerController mainController;
  late List<VideoPlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    repo = CinemaRepository();

    mainController = YoutubePlayerController.fromVideoId(
      videoId: "GkAUsuGMqm8",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

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
          if(_selectedPage != "ShowReel")
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
      case "ShowReel":
        return _buildHomeContent();
      case "Bio | Contact":
        return _buildBioSection();
      case "Featured Work":
        return _buildFeaturedWork();
      // case "Gallery":
      //   return _buildPhotosSection(context);
      case "Associated Work":
        return _buildCinematography();
      case "Feature Films":{
        final  List<Trailer> filmImages = repo.getFilms();
        return _buildVideoSection(filmImages);
      }
      case "Short Films":{
        final  List<Trailer> shortFilms = repo.getShortFilms();
        return _buildVideoSection(shortFilms);
      }
      case "Musicals":{
        final  List<Trailer> musicals = repo.getMusicals();
        return _buildVideoSection(musicals);
      }
      case "Web Series" :{
        final  List<Trailer> webSeries = repo.getWebSeries();
        return _buildVideoSection(webSeries);
      }
      // case "Narratives" :{
      //   final  List<Trailer> narratives = repo.getNarratives();
      //   return _buildVideoSection(narratives);
      // }
      case "Commercials":
        {
          final  List<Trailer> commercials = repo.getCommercials();
          return _buildVideoSection(commercials);
        }
      default:
        return _buildPlaceholderPage(_selectedPage);
    }
  }

  /// HEADER
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                _selectedPage = "ShowReel";
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Naveen Chempodi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  "Cinematographer",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
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
  }

  Widget _buildHomeContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

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
                  crossAxisCount: maxWidth < 600 ? 1 : 2, // 1 on small screens, 2 on larger
                  crossAxisSpacing: 40,  // 🔹 more even horizontal gap
                  mainAxisSpacing: 40,   // 🔹 more even vertical gap
                  childAspectRatio: 16 / 9, // 🔹 classic video shape
                ),
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  final controller = _controllers[index];

                  return controller.value.isInitialized
                      ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        child: SizedBox.expand( // 🔹 force to fill grid cell
                          child: FittedBox(
                            fit: BoxFit.cover, // fill while keeping proportions
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                      ),

                      // 🔹 Play / Pause Button
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
                },
              ),
            ),

            const SizedBox(height: 40),
            _buildFooter(),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildMenuOverlay() {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.95),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _menuItem("ShowReel"),
          _menuItem("Featured Work"),
          _menuItem("Associated Work"),
          _menuItem("Bio | Contact"),
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
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedWork() {
    int selectedCategory = 0;

    final List<String> titles = [
      "Short Films",
      "Web Series",
      "Musicals",
      "Commercials",
    ];
    return StatefulBuilder(
      builder: (context, setState) {
        _selectedPage = titles[selectedCategory];

        return LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 900;
            double horizontalPadding = isWide ? 200 : 20;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 40, horizontalPadding, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: List.generate(titles.length, (index) {
                      final isSelected = selectedCategory == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                            _selectedPage = titles[selectedCategory];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const Text("TRAILERS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 20),
                  _buildMainContent()
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCinematography() {
    int selectedCategory = 0;

    final List<String> titles = [
      "Feature Films",
      "Web Series",
      "Musicals",
      "Commercials",
    ];
    return StatefulBuilder(
      builder: (context, setState) {
        _selectedPage = titles[selectedCategory];

        return LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 900;
            double horizontalPadding = isWide ? 200 : 20;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 40, horizontalPadding, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: List.generate(titles.length, (index) {
                      final isSelected = selectedCategory == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                            _selectedPage = titles[selectedCategory];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const Text("TRAILERS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 20),
                  _buildMainContent()
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoSection(List<Trailer> filmImages) {
    int selectedId = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        List<String> images = filmImages.isNotEmpty
            ? (filmImages[selectedId].photoPaths ?? [])
            : [];

        if (filmImages.isNotEmpty) {
        setState((){
          mainController.loadVideoById(videoId: filmImages[selectedId].trailerId);
        });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filmImages.length,
                itemBuilder: (context, index) {
                  final videoId = filmImages[index].trailerId;
                  final thumbnailUrl =
                      "https://img.youtube.com/vi/$videoId/0.jpg";

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedId = index;
                        images = filmImages[index].photoPaths ?? [];
                        mainController.loadVideoById(videoId: videoId);
                      });
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedId == index
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🎬 Main YouTube Video
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(controller: mainController),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "CREDITS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // 📃 Film Credits
            if (filmImages.isNotEmpty)
              _buildCreditsSection(filmImages[selectedId])
            else
              const Text(
                "No details available for this video.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

            const SizedBox(height: 30),
            // if (images.isNotEmpty)
            //   _bottomImageSection(images),
          ],
        );
      },
    );
  }

  /// Helper widget for credits
  Widget _buildCreditsSection(Trailer film) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (film.filmName.isNotEmpty)
          _creditRow("Film", film.filmName),
        if (film.yearOfRelease.isNotEmpty)
          _creditRow("Released in", film.yearOfRelease),
        if (film.directorName.isNotEmpty)
          _creditRow("Director", film.directorName),
        if (film.dopName.isNotEmpty)
          _creditRow("Cinematographer", film.dopName),
        if (film.myDesignation.isNotEmpty)
          _creditRow(film.myDesignation, "Naveen Chempodi"),
        if (film.productionHouse.isNotEmpty)
          _creditRow("Production house", film.productionHouse),
      ],
    );
  }

  /// Generic credit row
  Widget _creditRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomImageSection(List<String> imagePaths) {

    final PageController pageController = PageController();
    int selectedIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imagePaths.length,
                    onPageChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),

                // Left button
                Positioned(
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      if (selectedIndex > 0) {
                        selectedIndex--;
                        setState(() {});
                        pageController.animateToPage(
                          selectedIndex,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                // Right button
                Positioned(
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      if (selectedIndex < imagePaths.length - 1) {
                        selectedIndex++;
                        setState(() {});
                        pageController.animateToPage(
                          selectedIndex,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < imagePaths.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                          });
                          pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              imagePaths[i],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhotosSection(BuildContext context) {
    final List<String> streetPhotos = [
      "assets/images/image24.jpeg",
      "assets/images/image6.jpeg",
      "assets/images/image17.jpeg",
      "assets/images/image7.jpeg",
      "assets/images/image15.jpg",
      "assets/images/image16.jpeg",
      "assets/images/image18.jpeg",
      "assets/images/image8.jpeg",
      "assets/images/image11.jpeg",
      "assets/images/image12.jpeg",
      "assets/images/image13.jpeg",
      "assets/images/image5.jpeg",
      "assets/images/image4.jpeg",
      "assets/images/image3.jpeg",
      "assets/images/image2.jpeg",
      "assets/images/image9.jpeg",
      "assets/images/image19.png",
      "assets/images/image20.png",
      "assets/images/image22.png",
      "assets/images/image23.png",
    ];

    int _getCrossAxisCount(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      if (width < 600) return 2; // Mobile
      if (width < 900) return 3; // Tablet
      return 4; // Desktop
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(), // ✅ scrollable grid
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: streetPhotos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: InteractiveViewer(
                          clipBehavior: Clip.none,
                          child: Image.asset(
                            streetPhotos[index],
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.9,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              streetPhotos[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'naveenchempodi@email.com',
      query: 'subject=Let\'s Connect&body=Hi Naveen,', // optional
    );

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch $emailUri');
    }
  }

  Widget _buildBioSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;

        return SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(isWide ? 100 : 20),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      "assets/images/image21.png",
                      fit: BoxFit.cover,
                      height: 400,
                    ),
                  ),
                  const SizedBox(width: 40),

                  // Right side text
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hi, my name is Naveen Chempodi.\nI'm a cinematographer based in Cochin, Kerala.",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Over the past 8 years, I have brought stories to life as a cinematographer for commercials,\nshort films, feature films, and musicals, partnering with renowned production houses and brands.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "-",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Contact:",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Phone: 99954407888",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.6),
                        ),
                        const Text(
                          "Email: naveenchempodi@gmail.com",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _launchEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text("Connect"),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/image21.png",
                      fit: BoxFit.cover, height: 300),
                  const SizedBox(height: 12),
                  const Text(
                    "Hi, my name is Naveen Chempodi.\nI'm a cinematographer based in Cochin, Kerala",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Over the past 8 years, I have brought stories to life as a cinematographer for commercials, short films, feature films, and musicals, partnering with renowned production houses and brands.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "-",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Contact:",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Phone: 99954407888",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.6),
                  ),
                  const Text(
                    "Email: naveenchempodi@gmail.com",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _launchEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Connect"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
