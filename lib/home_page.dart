import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_website/repository/cinema_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_widgets/associated_widget.dart';
import 'custom_widgets/bio_widget.dart';
import 'custom_widgets/feature_detailed.dart';
import 'custom_widgets/feature_widget.dart';
import 'custom_widgets/associated_details_page.dart';
import 'custom_widgets/show_reel_widget.dart';
import 'models/cinematograpghy_modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  String _selectedPage = "Home";
  String _subCategory = "Home";
  String designation = "Director of photography";
  late AnimationController _iconController;
  late CinemaRepository repo;
  FeaturedWork? _selectedFilm;

  final menuItems = [
    "Commercial",
    "Music video",
    "Short film",
    "Associated film",
    "Associated commercial",
    "About"
  ];

  @override
  void initState() {
    super.initState();
    repo = CinemaRepository();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Restore state from URL on reload
    final path = html.window.location.pathname ?? "/";
    _restoreStateFromUrl(path);

    // Listen to browser back/forward
    html.window.onPopState.listen((event) {
      final path = html.window.location.pathname ?? "/";
      _restoreStateFromUrl(path);
    });
  }

  void _restoreStateFromUrl(String path) {
    setState(() {
      if (path == "/" || path == "/home") {
        _selectedPage = "Home";
        _subCategory = "Home";
        _selectedFilm = null;
      } else if (path.startsWith("/details")) {
        _subCategory = "Details";
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
         bool isMobile = constraints.maxWidth < 900;
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
                    setState(() {
                      _selectedPage = "Home";
                      _subCategory = "Home";
                      _selectedFilm = null;
                    });
                    html.window.history.pushState(null, "Home", "/");
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
                    children: List.generate(menuItems.length * 2 - 1, (index) {
                      if (index.isOdd) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "/",
                            style: GoogleFonts.alef(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 44, 42, 42),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        );
                      } else {
                        final item = menuItems[index ~/ 2];
                        return GestureDetector(
                          onTap: () => _navigateTo(item),
                          child: Text(
                            item,
                            style: GoogleFonts.alef(
                              fontSize: 14,
                              fontWeight: _selectedPage == item
                                  ? FontWeight.bold
                                  : FontWeight.w400,
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
    final isMobile = MediaQuery.of(context).size.width < 900;
    return WillPopScope(
      onWillPop: () async {
        if (_subCategory == "Details") {
          setState(() {
            _subCategory = _selectedPage;
            _selectedFilm = null;
          });
          html.window.history.back();
          return false;
        }
        if (_selectedPage != "Home") {
          setState(() {
            _selectedPage = "Home";
            _subCategory = "Home";
          });
          html.window.history.back();
          return false;
        }
        return true; // exit if on Home
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
                    _buildMainContent(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // ✅ This stays at the bottom
            _buildFooter(),
          ],
        ),
      )

    );
  }

  Widget _buildMainContent() {
    if (_subCategory == "Details") {
      if (_selectedFilm != null) {
        if (_selectedFilm?.videoPaths.isEmpty == true) {
          return AssociatedDetailScreen(film: _selectedFilm!, designation: designation);
        }
        return FeatureDetailedWidget(film: _selectedFilm!, designation: designation);
      }
      return const Center(child: Text("No film selected"));
    }
    switch (_selectedPage) {
      case "Home":
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
      case "Details":
        if (_selectedFilm?.videoPaths.isEmpty == true) {
          return AssociatedDetailScreen(film: _selectedFilm!, designation: designation);
        }
        return FeatureDetailedWidget(film: _selectedFilm!, designation: designation);
      case "About":
        return BioSection();
      case "Commercial":
        final List<FeaturedWork> works = repo.getFeatureWork("Commercial");
        return FeaturedWorkGrid(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = "Details";
              _selectedFilm = film;
            });
            html.window.history.pushState(null, "Details", "/details");
          },
        );
      case "Music video":
        final List<FeaturedWork> works = repo.getFeatureWork("Music video");
        return FeaturedWorkGrid(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = "Details";
              _selectedFilm = film;
            });
            html.window.history.pushState(null, "Details", "/details");
          },
        );
      case "Short film":
        final List<FeaturedWork> works = repo.getFeatureWork("Short film");
        return FeaturedWorkGrid(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = "Details";
              _selectedFilm = film;
            });
            html.window.history.pushState(null, "Details", "/details");
          },
        );
      case "Associated film":
        final List<AssociatedWork> works = repo.getFilms();
        return AssociatedWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = "Details";
              _selectedFilm = FeaturedWork(
                trailerId: film.trailerId,
                yearOfRelease: "",
                description: "",
                videoPaths: [],
                poster: film.poster,
                filmName: film.title,
                credit: Credit(
                  director: "",
                  screenplay: "",
                  editor: "",
                  art_director: "",
                  sync_sound: "",
                  music: "",
                  production: "",
                  di: "",
                ),
                category: film.category,
              );
              designation = film.designation;
            });
            html.window.history.pushState(null, "Details", "/details");
          },
        );
      case "Associated commercial":
        final List<AssociatedWork> works = repo.getCommercials();
        return AssociatedWidget(
          films: works,
          onTrailerTap: (film) {
            setState(() {
              _subCategory = "Details";
              _selectedFilm = FeaturedWork(
                trailerId: film.trailerId,
                yearOfRelease: "",
                description: "",
                videoPaths: [],
                poster: film.poster,
                filmName: film.title,
                credit: Credit(
                  director: "",
                  screenplay: "",
                  editor: "",
                  art_director: "",
                  sync_sound: "",
                  music: "",
                  production: "",
                  di: "",
                ),
                category: film.category,
              );
              designation = film.designation;
            });
            html.window.history.pushState(null, "Details", "/details");
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
        children: menuItems.map((e) => _menuItem(e)).toList(),
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
                color: const Color.fromARGB(255, 44, 42, 42),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            if (text != "About")
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
          "https://www.instagram.com/naveenchempodi?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.linkedin,
          "https://www.linkedin.com/in/naveen-chempodi-5482a224a/"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.imdb,
          "https://www.imdb.com/name/nm11117697/?ref_=nv_sr_srsg_0_tt_0_nm_1_in_0_q_naveen%2520chempodi"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.link,
          "https://linktr.ee/naveen_chempodi?utm_source=linktree_profile_share"),
      const SizedBox(width: 15),
      _socialIcon(FontAwesomeIcons.facebook, "https://..."),
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
