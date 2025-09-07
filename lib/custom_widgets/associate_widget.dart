import 'package:flutter/material.dart';
import 'package:portfolio_website/custom_widgets/thumbnail_widget.dart';

import '../models/cinematograpghy_modals.dart';
import '../repository/cinema_repo.dart';

class AssoWorkSection extends StatefulWidget {
  final void Function(String trailerId) onCategoryChanged;

  const AssoWorkSection({super.key, required this.onCategoryChanged});

  @override
  State<AssoWorkSection> createState() => _AssoWorkSectionState();
}

class _AssoWorkSectionState extends State<AssoWorkSection> {
  int selectedCategory = 0;
  String _selectedSubPage = "Feature Films";
  late CinemaRepository repo;
  @override
  void initState() {
    super.initState();
    repo = CinemaRepository();
  }

  final List<String> titles = [
    "Feature Films",
    "Web Series",
    "Commercial ads",
  ];

  @override
  Widget build(BuildContext context) {
    _selectedSubPage = titles[selectedCategory];

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
                        _selectedSubPage = titles[selectedCategory];
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

              /// Replace this with your actual content builder
             _buildSubContent(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPosterView(List<FeaturedWork> films) {
    return StatefulBuilder(
      builder: (context, setState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 900;
            int crossAxisCount = isWide ? 4 : 2;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2 / 3, // poster ratio
                    ),
                    itemCount: films.length,
                    itemBuilder: (context, index) {
                      final film = films[index];
                      return GestureDetector(
                        onTap: () =>   widget.onCategoryChanged(film.trailerId),
                        child: ClipRRect(
                          child: Image.asset(
                            film.poster,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 40),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubContent() {
    switch (_selectedSubPage) {
      case "Feature Films":{
        final  List<FeaturedWork> filmImages = repo.getFilms();
        return _buildPosterView(filmImages);
      }
      case "Web Series" :{
        final  List<FeaturedWork> filmImages = repo.getWebSeries();
        return _buildPosterView(filmImages);
      }
      case "Commercial ads":
        {
          final  List<FeaturedWork> commercials = repo.getCommercials();
          return ThumbnailGridView(
            films: commercials,
            onTrailerTap: (trailerId) {
              widget.onCategoryChanged(trailerId);
            },
          );
        }
      default:
        return _buildPlaceholderPage(_selectedSubPage);
    }
  }

  Widget _buildPlaceholderPage(String page) {
    return Center(
      child: Text(
        "$page Page (Coming Soon)",
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}
