import 'dart:convert';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/cast_model.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/details_tvshow_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/models/tvshow_model.dart';

class TheMovieApiService {
  ///Get Popular Movies Service (...3/movie/popular)
  Future<List<Movie>> getPopularMoviesService(
      int popularPage, String language) async {
    List<Movie> movieList = [];

    final url = Uri.http(urlTheMovieDB, '3/movie/popular', {
      'api_key': apiKey,
      'language': language,
      'page': popularPage.toString(),
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
    }
    return movieList;
  }

  ///Get In Cimena Movies Service (...3/movie/now_playing)
  Future<List<Movie>> getNowPlaying(String language) async {
    final url = Uri.http(urlTheMovieDB, '3/movie/now_playing', {
      'api_key': apiKey,
      'language': language,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      List<Movie> movieList = [];
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
      return movieList;
    }
    return [];
  }

  ///Get Popular Tv Show Service (...3/tv/popular)
  Future<List<TvShow>> getTvShow(int popularTvShowPage, String language) async {
    final url = Uri.http(urlTheMovieDB, '3/tv/popular', {
      'api_key': apiKey,
      'language': language,
      'page': popularTvShowPage.toString()
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      List<TvShow> movieList = [];
      for (var movie in decoded['results']) {
        movieList.add(TvShow.fromJsonMap(movie));
      }
      return movieList;
    }
    return [];
  }

  ///Get Cast from Movie or TV Show
  ///movieId  Movie or TV Show Id
  ///language Request Language
  ///type Movie('movie') or TV Show ('tv')
  Future<List<Actor>> getCast(
      String movieId, String language, String type) async {
    final url = Uri.https(urlTheMovieDB, '3/$type/$movieId/credits', {
      'api_key': apiKey,
      'language': language,
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    return Cast.fromJsonList(decodedData['cast']).performer;
  }

  ///Get Details from Movie or TV Show
  ///movieId  Movie or TV Show Id
  ///language Request Language
  ///type Movie('movie') or TV Show ('tv')
  ///Note: for TV Show, the request is different, it needs to be convert to Future MovieDetails
  Future<MovieDetails> getDetails(
      String movieId, String language, String type) async {
    final url = Uri.https(urlTheMovieDB, '3/$type/$movieId', {
      'api_key': apiKey,
      'language': language,
      'page': '1',
    });
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    if (type == 'movie') {
      return MovieDetails.fromJson(decodedData);
    } else {
      var tvShow = TvShowDetails.fromJson(decodedData);
      var movieDetails = MovieDetails();

      movieDetails.adult = tvShow.adult;
      movieDetails.backdropPath = tvShow.backdropPath;
      movieDetails.budget = 0;
      movieDetails.homepage = tvShow.homepage;
      movieDetails.id = tvShow.id;
      movieDetails.imdbId = '0';
      movieDetails.originalLanguage = tvShow.originalLanguage;
      movieDetails.originalTitle = tvShow.originalName;
      movieDetails.overview = tvShow.overview;
      movieDetails.popularity = tvShow.popularity;
      movieDetails.posterPath = tvShow.posterPath;
      movieDetails.productionCountries = tvShow.productionCountries;
      movieDetails.productionCompanies = tvShow.productionCompanies;
      movieDetails.genres = tvShow.genres;
      movieDetails.spokenLanguages = tvShow.spokenLanguages;
      movieDetails.releaseDate = tvShow.firstAirDate;
      movieDetails.revenue = 0;
      movieDetails.runtime =
          tvShow.episodeRunTime!.isNotEmpty ? tvShow.episodeRunTime![0] : 0;
      movieDetails.status = tvShow.status;
      movieDetails.tagline = tvShow.tagline;
      movieDetails.title = tvShow.name;
      movieDetails.video = false;
      movieDetails.voteAverage = tvShow.voteAverage;
      movieDetails.voteCount = tvShow.voteCount;
      return movieDetails;
    }
  }

  ///Get Details from TV Show
  ///movieId  Movie or TV Show Id
  ///language Request Language
  Future<MovieDetails> getDetailsTvShow(String movieId, String language) async {
    final url = Uri.https(urlTheMovieDB, '3/tv/$movieId',
        {'api_key': apiKey, 'language': language, 'page': '1'});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    return MovieDetails.fromJson(decodedData);
  }

  ///Get Search Movie
  ///query  Movie Query
  ///language Request Language
  Future<List<Movie>> getSearchMovies(String query, String language) async {
    List<Movie> movieList = [];
    final url = Uri.https(urlTheMovieDB, '3/search/movie', {
      'api_key': apiKey,
      'language': language,
      'query': query,
    });
    final response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
    }
    return movieList;
  }

  ///Get Movie Info by ID
  Future<MovieDetails> getSearchMovieById(
      String movieId, String language) async {
    final url = Uri.https(urlTheMovieDB, '3/movie/$movieId', {
      'api_key': apiKey,
      'language': language,
    });
    final response = await http.get(url);
    final decoded = await json.decode(response.body);
    var movie = MovieDetails.fromJson(decoded);
    return movie;
  }

  ///Get TvShow Info by ID
  Future<MovieDetails> getSearchTvShowById(
      String movieId, String language) async {
    final url = Uri.https(urlTheMovieDB, '3/tv/$movieId', {
      'api_key': apiKey,
      'language': language,
    });
    final response = await http.get(url);
    final decoded = await json.decode(response.body);
    var series = TvShowDetails.fromJson(decoded);
    MovieDetails movie = MovieDetails();
    movie.title = series.name;
    movie.originalTitle = series.originalName ?? series.name;
    movie.video = false;
    movie.id = series.id;
    movie.adult = series.adult;
    movie.backdropPath = series.backdropPath;
    movie.voteCount = series.voteCount;
    movie.status = series.status;
    movie.tagline = series.tagline;
    movie.originalLanguage = series.originalLanguage;
    movie.spokenLanguages = series.spokenLanguages;
    movie.voteAverage = series.voteAverage;
    movie.revenue = 0;
    movie.productionCompanies = series.productionCompanies;
    movie.productionCountries = series.productionCountries;
    movie.imdbId = '';
    movie.budget = movie.budget;
    movie.voteAverage = series.voteAverage;
    movie.releaseDate = '';
    movie.genres = series.genres;
    movie.popularity = series.popularity;
    movie.homepage = series.homepage;
    movie.posterPath = series.posterPath;
    movie.releaseDate = series.firstAirDate;
    movie.runtime = 0;
    movie.overview = series.overview;
    return movie;
  }
}
