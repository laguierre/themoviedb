class Movie {
  Movie({
    required this.voteCount,
    required this.id,
    required this.video,
    required this.voteAverage,
    required this.title,
    required this.popularity,
    required this.posterPath,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.backdropPath,
    required this.adult,
    required this.overview,
    required this.releaseDate,
    required this.mediaType,
  });

  String uniqueId = '';
  int voteCount = 0;
  int id = 0;
  bool video = false;
  double voteAverage = 0.0;
  String title = '';
  double popularity;
  String posterPath = '';
  String originalLanguage = '';
  String originalTitle = '';
  List<int> genreIds = [];
  String backdropPath = '';
  bool adult = false;
  String overview = '';
  String releaseDate = '';
  String mediaType = '';

  factory Movie.fromJsonMap(dynamic json) => Movie(
        voteCount: json['vote_count'] ?? 0,
        id: json['id'] ?? 0,
        video: json['video'] ?? false,
        voteAverage:
            (json['vote_average'] != null) ? (json['vote_average'] / 1.0) : 0.0,
        title: json['title'] ?? json['original_name'] ?? "N/A",
        popularity:
            (json['popularity'] != null) ? (json['popularity'] / 1) : 0.0,
        posterPath: json['poster_path'] ?? '',
        originalLanguage: json['original_language'] ?? "N/A",
        originalTitle: json['original_title'] ?? json['original_name'] ?? "N/A",
        genreIds:
            json['genre_ids'] != null ? json['genre_ids'].cast<int>() : [],
        backdropPath: json['backdrop_path'] ?? '',
        adult: json['adult'] ?? false,
        overview: json['overview'] ?? "N/A",
        releaseDate: json['release_date'] ?? "N/A",
        mediaType: json["media_type"] ?? "N/A",
      );

  getPosterImg() {
    if (posterPath.isEmpty) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg() {
    if (posterPath.isEmpty) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}
