import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_website/repository/cinema_repo.dart';
import 'package:portfolio_website/util_class.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_widgets/bio_widget.dart';
import 'custom_widgets/work_detail_widget.dart';
import 'custom_widgets/work_item_listing_widget.dart';
import 'custom_widgets/show_reel_widget.dart';
import 'models/cinematography_modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  String _selectedPage = Constants.HOME;
  String _subCategory = Constants.HOME;
  late AnimationController _iconController;
  late CinemaRepository repo;
  WorkDataModel? _selectedFilm;

  @override
  void initState() {
    super.initState();
    repo = CinemaRepository();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Restore state from URL on reload
    // final path = html.window.location.pathname ?? "/";
   // _restoreStateFromUrl(path);

    // Listen to browser back/forward
    html.window.onPopState.listen((event) {
      if (_selectedPage == Constants.HOME) return;
      final path = html.window.location.pathname ?? "/";
      if (!(_selectedPage == Constants.HOME && path == "/")) {
        _restoreStateFromUrl(path);
      }
    });
  }


  void _restoreStateFromUrl(String path) {
    setState(() {
      if (path == "/" || path == Constants.PATH_HOME) {
        _selectedPage = Constants.HOME;
        _subCategory = Constants.HOME;
        _selectedFilm = null;
      } else if (path.startsWith(Constants.PATH_DETAILS)) {
        _subCategory = Constants.DETAILS;
      } else {
        final normalized = path.replaceAll("/", "").replaceAll("-", " ");
        _selectedPage = _capitalize(normalized);
        _subCategory = _selectedPage;
      }
    });
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });
  }

  void _navigateTo(String page) {
    setState(() {
      _isMenuOpen = false;
      _iconController.reverse();
      _selectedPage = page;
      _subCategory = _selectedPage;
    });
    html.window.history.pushState(null, page, '/${page.toLowerCase().replaceAll(" ", "-")}');
  }

  Widget _buildCustomHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        double fontSize1 = isMobile ? 32 : 38;
        double fontSize2 = isMobile ? 22 : 24;

        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if(_selectedPage == Constants.HOME){
                      _navigateTo(Constants.ABOUT);
                    }else{
                      _navigateTo(Constants.HOME);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "NAVEEN CHEMPODI",
                        style: GoogleFonts.alef(
                          fontSize: fontSize1,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Cinematographer",
                        style: GoogleFonts.alef(
                          fontSize: fontSize2,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (!isMobile)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(Constants.menuItems.length * 2 - 1, (index) {
                      if (index.isOdd) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.stop, // solid circle
                            size: 6, // small size to look like a dot
                            color: const Color.fromARGB(255, 44, 42, 42),
                          ),
                        );
                      } else {
                        final item = Constants.menuItems[index ~/ 2];
                        return GestureDetector(
                          onTap: () => _navigateTo(item),
                          child: Text(
                            item,
                            style: GoogleFonts.alef(
                              fontSize: 14,
                              fontWeight:
                              _selectedPage == item ? FontWeight.bold : FontWeight.w400,
                              color: _selectedPage == item
                                  ? Colors.black
                                  : const Color.fromARGB(255, 44, 42, 42),
                            ),
                          ),
                        );
                      }
                    }),
                  )
                else
                  IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _iconController,
                      color: const Color.fromARGB(255, 44, 42, 42),
                      size: 24,
                    ),
                    onPressed: _toggleMenu,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return WillPopScope(
        onWillPop: () async {
          if (_selectedPage == Constants.HOME ) {
            // Already on home → allow app exit
            return true;
          }
          else {
            // Go back in browser history, will trigger _restoreStateFromUrl
           html.window.history.back();
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCustomHeader(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              child: child,
                            ),
                          );
                        },
                        child: (isMobile && _isMenuOpen)
                            ? _buildMenuOverlay()
                            : const SizedBox(),
                      ),
                      SizedBox(height: 30),
                      _buildMainContent(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        )

    );
  }

  Widget _buildMainContent() {
    if (_subCategory == Constants.DETAILS) {
      if (_selectedFilm != null) {
        return WorkDetailWidget(film: _selectedFilm!);
      }
      return  Center(child:
      Text("Page not available",
          style: GoogleFonts.akatab(
            color: const Color.fromARGB(255, 44, 42, 42),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )));
    }

    switch (_selectedPage) {
      case Constants.HOME:
        return ShowReelWidget(
          films: repo.getHomeData(),
          onCardTap: (category) {
            setState(() {
              _selectedPage = category;
              _subCategory = _selectedPage;
            });
            html.window.history.pushState(null, category, '/${category.toLowerCase().replaceAll(" ", "-")}');
          },
        );
      case Constants.ABOUT:{
        return BioSection();
      }
      case Constants.COMMERCIAL:{
        final List<WorkDataModel> works = repo.getFeatureWork(Constants.COMMERCIAL);
        return WorkListingGridWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = Constants.DETAILS;
              _selectedFilm = film;
            });
            html.window.history.pushState(null, Constants.DETAILS, Constants.PATH_DETAILS);
          },
        );
      }
      case Constants.MUSIC_VIDEO:
        final List<WorkDataModel> works = repo.getFeatureWork(Constants.MUSIC_VIDEO);
        return WorkListingGridWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = Constants.DETAILS;
              _selectedFilm = film;
            });
            html.window.history.pushState(null, Constants.DETAILS, Constants.PATH_DETAILS);
          },
        );
      case Constants.SHORT_FILM:
        final List<WorkDataModel> works = repo.getFeatureWork(Constants.SHORT_FILM);
        return WorkListingGridWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = Constants.DETAILS;
              _selectedFilm = film;
            });
            html.window.history.pushState(null, Constants.DETAILS, Constants.PATH_DETAILS);
          },
        );
      case Constants.ASSOCIATED_FILM:
        final List<WorkDataModel> works = repo.getFilms();
        return WorkListingGridWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = Constants.DETAILS;
              _selectedFilm = film;
            });
            html.window.history.pushState(null, Constants.DETAILS, Constants.PATH_DETAILS);
          },
        );
      case Constants.ASSOCIATED_COMMERCIAL:
        final List<WorkDataModel> works = repo.getCommercials();
        return WorkListingGridWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = Constants.DETAILS;
              _selectedFilm = film;
            });
            html.window.history.pushState(null, Constants.DETAILS, Constants.PATH_DETAILS);
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: Constants.menuItems.map((e) => _menuItem(e)).toList(),
      ),
    );
  }

  Widget _menuItem(String text) {
    return GestureDetector(
      onTap: () => _navigateTo(text),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Text(
              text,
              style: GoogleFonts.akatab(
                color: Color.fromARGB(255, 44, 42, 42),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            if (text != Constants.ABOUT)
              const Divider(
                color: Color.fromARGB(255, 44, 42, 42),
                thickness: 1,
                indent: 10,
                endIndent: 10,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(String page) {
    return Center(
      child: Text(
        "Something went wrong!",
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
            children: [
              const SizedBox(height: 10),
              _footerIcons(),
              const SizedBox(height: 20),
              _footerText()
            ],
          ),
        );
      },
    );
  }

  Widget _footerText() => Text(
    "© 2025 Naveen Chempodi",
    style: GoogleFonts.akatab(fontSize: 13, color: Colors.grey, letterSpacing: 0.5),
  );

  Widget _footerIcons() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialIcon(FontAwesomeIcons.instagram,
          Constants.INSTAGRAM_LINK),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.imdb,
          Constants.IMDB_LINK),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.link,
          Constants.LISK_TREE_LINK),
    ],
  );

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