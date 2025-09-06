import 'package:flutter/material.dart';

import '../models/cinematograpghy_modals.dart';

class ThumbnailGridView extends StatelessWidget {
  final List<Trailer> films;
  final void Function(String trailerId) onTrailerTap;

  const ThumbnailGridView({
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: films.length,
                itemBuilder: (context, index) {
                  final film = films[index];
                  return GestureDetector(
                    onTap: () => onTrailerTap(film.trailerId),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        film.poster,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error, size: 40),
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
  }
}

