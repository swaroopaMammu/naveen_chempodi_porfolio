import 'package:flutter/material.dart';

class PhotosSection extends StatelessWidget {
  final List<String> photos;

  const PhotosSection({super.key, required this.photos});

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Tablet
    return 4; // Desktop
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: photos.length,
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
                            photos[index],
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
              photos[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
