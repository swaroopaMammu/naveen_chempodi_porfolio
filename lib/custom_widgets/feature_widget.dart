import 'package:flutter/material.dart';

import '../models/cinematograpghy_modals.dart';

class FeaturedWorkGrid extends StatelessWidget {
  final List<Trailer> films;
  final void Function(Trailer film) onTrailerTap;

  const FeaturedWorkGrid({
    super.key,
    required this.films,
    required this.onTrailerTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 900;
        int crossAxisCount = isWide ? 3 : 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 16 / 9,
            ),
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return _FeaturedWorkItem(
                film: film,
                onTap: () => onTrailerTap(film),
              );
            },
          ),
        );
      },
    );
  }
}

class _FeaturedWorkItem extends StatefulWidget {
  final Trailer film;
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
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
                  style: const TextStyle(
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
    );
  }
}
