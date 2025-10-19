import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/custom_widgets/work_grid_item_widget.dart';

import '../models/cinematography_modals.dart';

class WorkListingGridWidget extends StatefulWidget {
  final List<WorkDataModel> films;
  final void Function(WorkDataModel film) onTrailerTap;
  const WorkListingGridWidget({
    super.key,
    required this.films,
    required this.onTrailerTap
  });

  @override
  State<WorkListingGridWidget> createState() => _WorkListingGridWidgetState();
}

class _WorkListingGridWidgetState extends State<WorkListingGridWidget> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        int crossAxisCount = 2;
        if(constraints.maxWidth > 900){
          crossAxisCount = 3;
        }if(constraints.maxWidth < 600){
          crossAxisCount = 1;
        }
        double padding = isWide ? constraints.maxWidth*0.15 : 20;
        return Padding(
          padding:  EdgeInsets.only(left: padding,right: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 30,
                childAspectRatio: 16 / 12,
              ),
              itemCount: widget.films.length,
              itemBuilder: (context, index) {
                final film = widget.films[index];
                final isAssociated = film.designation1 != "Director of photography";
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GridWorkItemWidget(
                        film: film,
                        onTap: () {
                          widget.onTrailerTap(film);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      film.title,
                      style: GoogleFonts.akatab(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(
                255, 44, 42, 42),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      isAssociated? film.designation1 :film.category,
                      style: GoogleFonts.akatab(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if(film.designation2.isNotEmpty)
                    Text(
                      film.designation2,
                      style: GoogleFonts.akatab(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ]
          ),
        );
      },
    );
  }
}

