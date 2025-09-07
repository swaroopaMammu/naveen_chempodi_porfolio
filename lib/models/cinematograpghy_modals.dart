
class FeaturedWork {
  final String trailerId;
  final String filmName;
  final String description;
  final String yearOfRelease;
  final String category;
  final List<String> videoPaths;
  final String poster;
  final Credit credit;

  FeaturedWork({
    required this.trailerId,
    required this.filmName,
    required this.yearOfRelease,
    required this.category,
    required this.description,
    required this.videoPaths,
    required this.poster,
    required this.credit
  });
}

class AssociatedWork{
  final String trailerId;
  final String poster;
  AssociatedWork({
    required this.trailerId,
    required this.poster,
});
}

class Credit{
  final String director;
  final String screenplay;
  final String editor;
  final String art_director;
  final String sync_sound;
  final String production;
  final String di;

  Credit({
    required this.director,
    required this.screenplay,
    required this.editor,
    required this.art_director,
    required this.sync_sound,
    required this.production,
    required this.di,
  });
}
