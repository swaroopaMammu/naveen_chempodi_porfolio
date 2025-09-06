import 'package:flutter/material.dart';

class BottomImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final double height;
  final double thumbnailSize;

  const BottomImageCarousel({
    super.key,
    required this.imagePaths,
    this.height = 400,
    this.thumbnailSize = 50,
  });

  @override
  State<BottomImageCarousel> createState() => _BottomImageCarouselState();
}

class _BottomImageCarouselState extends State<BottomImageCarousel> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _goToPage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_selectedIndex < widget.imagePaths.length - 1) _goToPage(_selectedIndex + 1);
  }

  void _previousPage() {
    if (_selectedIndex > 0) _goToPage(_selectedIndex - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: widget.height,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                onPageChanged: (index) => setState(() => _selectedIndex = index),
                itemBuilder: (context, index) => Image.asset(
                  widget.imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            // Left arrow
            Positioned(
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _previousPage,
              ),
            ),
            // Right arrow
            Positioned(
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imagePaths.length,
                  (i) => GestureDetector(
                onTap: () => _goToPage(i),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      widget.imagePaths[i],
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
