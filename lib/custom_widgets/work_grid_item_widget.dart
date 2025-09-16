import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cinematography_modals.dart';

class GridWorkItemWidget extends StatefulWidget {
  final WorkDataModel film;
  final VoidCallback onTap;

  const GridWorkItemWidget({
    required this.film,
    required this.onTap,
  });

  @override
  State<GridWorkItemWidget> createState() => _GridWorkItemWidgetState();
}

class _GridWorkItemWidgetState extends State<GridWorkItemWidget> {
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
              if(widget.film.poster.isEmpty)
                ClipRRect(
                  child: Image.network(
                    "https://img.youtube.com/vi/${widget.film.trailerId}/0.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                )
              else
                Image.asset(
                  widget.film.poster,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
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