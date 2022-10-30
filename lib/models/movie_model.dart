/*class Movies {
  List<Movie> items = [];

  Movies.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final movie = Movie.fromJsonMap(item);
      items.add(movie);
    }
  }
}*/
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
  });

  String uniqueId = '';
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title = '';
  double popularity;
  String posterPath = '';
  String originalLanguage = '';
  String originalTitle = '';
  List<int> genreIds;
  String backdropPath = '';
  bool adult;
  String overview = '';
  String releaseDate = '';

  factory Movie.fromJsonMap(dynamic json) => Movie(
    voteCount : json['vote_count'],
    id : json['id'],
    video : json['video'] == null? "N/A" : json['video'],
    voteAverage : json['vote_average'] / 1,
    title : json['title'],
    popularity : json['popularity'] / 1,
    posterPath : json['poster_path'] == null? "N/A" : json['poster_path'],
    originalLanguage : json['original_language'],
    originalTitle : json['original_title'],
    genreIds : json['genre_ids'].cast<int>(),
    backdropPath : json['backdrop_path'] == null? "N/A" : json['backdrop_path'],
    adult : json['adult'],
    overview : json['overview'],
    releaseDate : json['release_date'],
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
